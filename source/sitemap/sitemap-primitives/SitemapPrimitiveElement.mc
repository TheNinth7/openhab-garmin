import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Base class for all primitive sitemap elements—those that do not 
 * contain other elements.
 *
 * Examples of primitive elements: `Switch`, `Text`
 * Examples of container elements: `Homepage`, `Frame`
 */
class SitemapPrimitiveElement extends SitemapElement {

    // JSON field names
    private const ITEM = "item";
    private const ITEM_NAME = "name";
    private const ITEM_TYPE = "type";
    private const ITEM_STATE = "state";
    private const ITEM_GROUP_TYPE = "groupType";

    private const ITEM_TYPE_GROUP = "Group";

    protected const NO_STATE = "NULL";

    // Fields read from the JSON
    // For the members declared private, there are public members 
    // further below, with processing applied ("normalized")
    public var itemName as String;
    public var unit as String = "";

    // If the state is missing, NULL or UNDEF it
    // is set to NULL, which is displayed as em dash by the widgets
    public var itemState as String;
    
    // If rawItemType is Group, the normalized itemType is
    // set to the groupType
    public var itemType as String;
    
    // For some elements, the widget label also contains state information,
    // which may include mappings and formatting. In this case, the state 
    // is exctracted from the label into the transformedState.
    public var transformedState as String;

    // Functions to tell whether the widget and the item have a state
    public function hasItemState() as Boolean {
        return !itemState.equals( NO_STATE );
    }
    public function hasWidgetState() as Boolean {
        return !transformedState.equals( NO_STATE );
    }
    
    // The label may include a state in the format:
    //   label [state]
    // This function parses the input into the actual label and the state,
    // returning both as a tuple: [0] = label, [1] = state.
    private function normalizeLabel( fullLabel as String ) as [String, String?] {
        var widgetLabel = fullLabel;
        var transformedState = null;
        var bracket = label.find( " [" ) as Number?;
        if( bracket != null ) {
            widgetLabel = label.substring( null, bracket ) as String?;
            if( widgetLabel == null ) {
                throw new JsonParsingException( "Label '" + label + "' does not have label before the [state]" );
            }
            transformedState = label.substring( bracket+2, label.length()-1 ) as String?;
        }
        return [widgetLabel, transformedState];
    }

    // Takes a state value from the JSON and returns it
    // set to NO_STATE if it is empty, NULL or UNDEF
    protected function normalizeItemState( value as String? ) as String {
        if( value == null 
            || value.equals( "" )
            || value.equals( "NULL" ) 
            || value.equals( "UNDEF" ) ) 
            {
            return NO_STATE;
        }
        return value;
    }
    // Apply an additional rule for the widget state
    protected function normalizeTransformedState( value as String? ) as String {
        value = normalizeItemState( value );
        // "-" can be provided for the widget state, indicating that it is not available
        if( value.equals( "-" ) ) {
            return NO_STATE;
        }
        return value;
    }


    // Constructor
    protected function initialize( data as JsonObject, isSitemapFresh as Boolean ) {
        // First initialize the super class
        // We need the label from the super class before continuing
        SitemapElement.initialize( data, isSitemapFresh );

        // For some elements, the label includes a state in the format:
        //   label [state]
        // We split the two, storing the actual label in the `label` member
        // and the state in `transformedState`.
        // In this case we do not use a "normalized" label member, because
        // the changed ("normalized") value should be also available where
        // the base class is used. 
        var normalizedLabel = normalizeLabel( label );
        label = normalizedLabel[0];
        transformedState = normalizeTransformedState( normalizedLabel[1] );

        // ... and then read all the elements
        var item = getItem( data );
        itemName =  getString( item, ITEM_NAME, "Element '" + label + "': item has no name" );

        var rawItemType =  getString( item, ITEM_TYPE, "Element '" + label + "': item has no type" );
        if( rawItemType.equals( ITEM_TYPE_GROUP ) ) {
            itemType =  getString( item, ITEM_GROUP_TYPE, "Element '" + label + "': group has no type" );
        } else {
            itemType = rawItemType;
        }

        itemState = normalizeItemState( item[ITEM_STATE] as String? );

        if( itemType.equals( "Dimmer" ) ) {
            unit = "%";
        } else if( itemType.equals( "Rollershutter" ) ) {
            unit = "%";
        }
    }

    protected function getItem( data as JsonObject ) as JsonObject {
        return getObject( data, ITEM, "Element '" + label + "': no item found" );
    }
}