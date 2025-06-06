import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Switch` elements.
 *
 * `SitemapSwitch` has a corresponding `SwitchItem` that provides item-specific
 * properties required only by this widget.
 *
 * The command mappings defined in the sitemap will be honored, as will the
 * command description from the associated item.
 *
 * Since the widget should reflect state changes immediately after a command—
 * even before the next sitemap update—it supports updates via the `updateState()` function.
 * 
 * For this reason, it includes special handling for the `transformedState` member
 * inherited from the base class. `transformedState` is overwritten using the
 * description from the sitemap element mapping. During updates, this transformation
 * is re-applied, including the command and state descriptions from the item.
 * See `transformState()` for more details.
 */
class SitemapSwitch extends SitemapWidget {

    // The associated item and its state
    public var item as SwitchItem;

    // The mappings from the sitemap element (widget)
    private var _mappings as CommandDescriptionArray;
    
    // Holds the command descriptions to be used by the widget (for non-toggle switches).
    // Priority is given to mappings defined in the sitemap. If none are present,
    // and the item provides command descriptions, those will be used instead.
    public var commandDescriptions as CommandDescriptionArray;

    // Constructor
    public function initialize( 
        json as JsonAdapter, 
        initSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapWidget.initialize( json, initSitemapFresh, asyncProcessing );

        // Obtain the item part of the element
        item = new SwitchItem( json.getObject( "item", "Switch '" + label + "' has no item" ) );

        // Read the mappings ...
        _mappings = SwitchItem.readCommandDescriptions( json.getOptionalArray( "mappings" ) );

        // ... and decide which command descriptions are to be used
        // If there are no widget mappings but there are
        // command descriptions, then we take those, otherwise
        // we take the widget mappings, even if empty
        if( _mappings.size() == 0 && item.commandDescriptions != null ) {
            commandDescriptions = item.commandDescriptions as CommandDescriptionArray; 
        } else {
            commandDescriptions = _mappings;
        }

        // For switch items, the mapping take precedence over the
        // transformed state provided in the sitemap element
        // Therefore we trigger a manual transformation here
        transformState();
    }


    // Returns true if mappings are defined (either via the mappings
    // in the sitemap or via command descriptions for the item)
    public function hasMappings() as Boolean {
        return commandDescriptions.size() > 0;
    }


    // To be used to update the state if a change
    // is triggered from within the app
    public function updateState( state as String ) as Void {
        // If the state in the sitemap is the same as we got passed
        // in there is no need to update. updateState is relatively
        // costly due to the lookup of the description
        if( ! item.state.equals( state ) ) {
            item.state = state;
            transformedState = Item.NO_STATE;
            transformState();
        }
    }
    
    // Transforms the raw state into a descriptive form for display.
    //
    // The transformation uses these sources in the following priority:
    // 1. A matching entry in the sitemap element’s mappings.
    // 2. The transformed state from the widget, if present.
    // 3. A matching entry in the item’s state descriptions.
    // 4. A matching entry in the item’s command descriptions.
    // 5. The raw state itself. If the state is numeric and a unit is defined for the item, the unit is appended.
    private function transformState() as Void {

        // First priority: lookup the mappings defined for the widget
        var localTransformedState = searchArray( 
            _mappings as BaseDescriptionArray, 
            item.state
        );

        if( localTransformedState == null ) {
            if( hasTransformedState() ) {
                // Second priority: 
                // If we got the state from the server, then the transformedState
                // may be filled and we'll just use it. 
                // For internal updates this is never the case, since we
                // set the transformedState to NO_STATE before calling this function
                return;
            } else if( item.stateDescriptions != null ) {
                // Third priority: lookup the state description
                localTransformedState = searchArray( 
                    item.stateDescriptions as BaseDescriptionArray, 
                    item.state 
                );
            }
        }

        // Fourth priority: we lookup the command descriptions
        if( localTransformedState == null && item.commandDescriptions != null ) {
            localTransformedState = searchArray( 
                item.commandDescriptions as BaseDescriptionArray, 
                item.state 
            );
        }

        // If all has failed, we just use the raw state
        if( localTransformedState == null ) {
            localTransformedState = item.state;
            // If the transformed state is numeric, then we
            // add the unit
            localTransformedState = 
                localTransformedState.toFloat() != null
                ? localTransformedState + item.unit
                : localTransformedState;
        }

        transformedState = localTransformedState;
    }

    // Search in an Array of BaseDescriptions for
    // the given state and if found return the label
    private static function searchArray( 
        descriptions as BaseDescriptionArray, 
        state as String 
    ) as String? {
        for( var i = 0; i < descriptions.size(); i++ ) {
            var description = descriptions[i];
            if( description.equalsById( state ) ) {
                return description.label;
            }
        }
        return null;
    }
}