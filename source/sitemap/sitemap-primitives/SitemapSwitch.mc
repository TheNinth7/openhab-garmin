import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Switch` elements.
 */
class SitemapSwitch extends SitemapPrimitiveElement {
    private var _widgetMappings  as CommandDescriptionArray;
    private var _itemCommandDescriptions as CommandDescriptionArray?;
    private var _itemStateDescriptions as StateDescriptionArray?;

    public var commandDescriptions as CommandDescriptionArray;

    // Accessor
    public function hasMappings() as Boolean {
        return commandDescriptions.size() > 0;
    }

    // Constructor
    public function initialize( data as JsonObject, isSitemapFresh as Boolean ) {
        SitemapPrimitiveElement.initialize( data, isSitemapFresh );

        // Obtain the item part of the element
        var item = getItem( data ) as JsonObject;

        // As start, we read the widget mappings
        _widgetMappings = readCommandDescriptions( data["mappings"] as JsonArray? );

        // Then we read the item's command descriptions, if there are any
        var cd = item["commandDescription"] as JsonObject?;
        if( cd != null ) {
            _itemCommandDescriptions = readCommandDescriptions( cd["commandOptions"] as JsonArray? );
        }

        // If there are no widget mappings but there are
        // command descriptions, then we take those, otherwise
        // we take the widget mappings, even if empty
        if( _widgetMappings.size() == 0 && _itemCommandDescriptions != null ) {
            commandDescriptions = _itemCommandDescriptions;       
        } else {
            commandDescriptions = _widgetMappings;
        }
        
        // And if there are state descriptions, we'll read them as well
        var sd = item["stateDescription"] as JsonObject?;
        if( sd != null ) {
            _itemStateDescriptions = readStateDescriptions( sd["options"] as JsonArray? );
        }

        transformedState = describeState();
    }

    // Used for reading both the widget's mapping and
    // the items command descriptions
    public function readCommandDescriptions( jsonCommandDescriptions as JsonArray? ) as CommandDescriptionArray {
        var commandDescriptions = new CommandDescriptionArray[0];
        if( jsonCommandDescriptions != null ) {
            for( var i = 0; i < jsonCommandDescriptions.size(); i++ ) {
                var jsonCommandDescription = jsonCommandDescriptions[i];
                commandDescriptions.add( 
                    new CommandDescription( 
                        getString( jsonCommandDescription, "command", "Element '" + label + "': command is missing from mapping/command description" ),
                        getOptionalString( jsonCommandDescription, "label" )
                    )
                );
            }
        }
        return commandDescriptions;
    }

    // Used for reading the items state descriptions
    public function readStateDescriptions( jsonStateDescriptions as JsonArray? ) as StateDescriptionArray {
        var stateDescriptions = new StateDescriptionArray[0];
        if( jsonStateDescriptions != null ) {
            for( var i = 0; i < jsonStateDescriptions.size(); i++ ) {
                var jsonStateDescription = jsonStateDescriptions[i];
                stateDescriptions.add( 
                    new StateDescription( 
                        getString( jsonStateDescription, "value", "Element '" + label + "': value is missing from state description" ),
                        getString( jsonStateDescription, "label", "Element '" + label + "': label is missing from state description" )
                ) );
            }
        }
        return stateDescriptions;
    }

    // To be used to update the state if a change
    // is triggered from within the app
    public function updateState( state as String ) as Void {
        // If the state in the sitemap is the same as we got passed
        // in there is no need to update. updateState is relatively
        // costly due to the lookup of the description
        if( ! itemState.equals( state ) ) {
            itemState = state;
            // If we update the state internally, the
            // calculated widget state is not valid anymore
            transformedState = NO_STATE;

            // Fill the state description
            transformedState = describeState();
        }
    }
    
    // Determines the state description
    private function describeState() as String {
        
        // First priority: lookup the mappings defined for the widget
        var localTransformedState = searchArray( 
            _widgetMappings as BaseDescriptionArray, 
            itemState 
        );

        // Second priority: lookup the state description
        // If we got the state from the server, then the transformedState
        // may be filled. For internal updates this is never the case
        // The transformedState contains a processed state based on the
        // state descriptions, so if it is present, we do not need
        // to search in the array
        if( localTransformedState == null ) {
            if( hasWidgetState() ) {
                localTransformedState = transformedState;
            } else if( _itemStateDescriptions != null ) {
                localTransformedState = searchArray( 
                    _itemStateDescriptions as BaseDescriptionArray, 
                    itemState 
                );
            }
        }

        // Third priority: we lookup the command descriptions
        if( localTransformedState == null && _itemCommandDescriptions != null ) {
            localTransformedState = searchArray( 
                _itemCommandDescriptions as BaseDescriptionArray, 
                itemState 
            );
        }

        // If all has failed, we just use the raw state
        if( localTransformedState == null ) {
            localTransformedState = itemState;
        }

        // If the transformed state is numeric, then we
        // add the unit
        localTransformedState = 
            localTransformedState.toFloat() != null
            ? localTransformedState + unit
            : localTransformedState;

        return localTransformedState;
    }

    // Search in an Array of BaseDescriptions for
    // the given state and if found return the label
    private function searchArray( descriptions as BaseDescriptionArray, state as String) as String? {
        for( var i = 0; i < descriptions.size(); i++ ) {
            var description = descriptions[i];
            if( description.equalsById( state ) ) {
                return description.label;
            }
        }
        return null;
    }
}