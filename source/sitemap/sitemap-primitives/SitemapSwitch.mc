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

    // The description of the state is what is displayed
    // on the UI for the state
    public var itemStateDescription as String;

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

        itemStateDescription = describeState();
        addUnitToStateDescription();
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
        normalizedItemState = state;
        // If we update the state internally, the
        // calculated widget state is not valid anymore
        widgetState = NO_STATE;

        // Fill the state description
        itemStateDescription = describeState();
        addUnitToStateDescription();
    }
    
    // Determines the state description
    private function describeState() as String {
        
        // First priority: lookup the mappings defined for the widget
        var localDesc = searchArray( 
            _widgetMappings as BaseDescriptionArray, 
            normalizedItemState 
        );

        // Second priority: lookup the state description
        // If we got the state from the server, then the widgetState
        // may be filled. For internal updates this is never the case
        // The widgetState contains a processed state based on the
        // state descriptions, so if it is present, we do not need
        // to search in the array
        if( localDesc == null ) {
            if( hasWidgetState() ) {
                localDesc = widgetState;
            } else if( _itemStateDescriptions != null ) {
                localDesc = searchArray( 
                    _itemStateDescriptions as BaseDescriptionArray, 
                    normalizedItemState 
                );
            }
        }

        // Third priority: we lookup the command descriptions
        if( localDesc == null && _itemCommandDescriptions != null ) {
            localDesc = searchArray( 
                _itemCommandDescriptions as BaseDescriptionArray, 
                normalizedItemState 
            );
        }

        // If all has failed, we just use the raw state
        if( localDesc == null ) {
            localDesc = normalizedItemState;
        }

        return localDesc;
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


    // This function can be used by subclasses to apply a unit to
    // a state, but only if the state is numeric
    private function addUnitToStateDescription() as Void {
        itemStateDescription = 
            itemStateDescription.toFloat() != null
            ? itemStateDescription + unit
            : itemStateDescription;
    }
}