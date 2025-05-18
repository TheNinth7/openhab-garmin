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
    private var itemState as String?;
    private var itemType as String;
    public var unit as String = "";

    // If the state is missing, NULL or UNDEF it
    // is set to NULL, which is displayed as em dash by the widgets
    public var normalizedItemState as String;
    
    // If itemType is Group, the normalized itemType is
    // set to the groupType
    public var normalizedItemType as String;
    
    // For some elements, the widget label also contains state information,
    // which may include mappings and formatting. In this case, the state 
    // is exctracted from the label into the widgetState.
    public var widgetState as String;

    // Functions to tell whether the widget and the item have a state
    public function hasItemState() as Boolean {
        return !normalizedItemState.equals( NO_STATE );
    }
    public function hasWidgetState() as Boolean {
        return !widgetState.equals( NO_STATE );
    }
    
    // The label may include a state in the format:
    //   label [state]
    // This function parses the input into the actual label and the state,
    // returning both as a tuple: [0] = label, [1] = state.
    private function normalizeLabel( fullLabel as String ) as [String, String?] {
        var widgetLabel = fullLabel;
        var widgetState = null;
        var bracket = label.find( " [" ) as Number?;
        if( bracket != null ) {
            widgetLabel = label.substring( null, bracket ) as String?;
            if( widgetLabel == null ) {
                throw new JsonParsingException( "Label '" + label + "' does not have label before the [state]" );
            }
            widgetState = label.substring( bracket+2, label.length()-1 ) as String?;
        }
        return [widgetLabel, widgetState];
    }

    // Takes a state value from the JSON and returns it
    // set to NO_STATE if it is empty, NULL or UNDEF
    protected function normalizeState( value as String? ) as String {
        if( value == null 
            || value.equals( "" )
            || value.equals( "NULL" ) 
            || value.equals( "UNDEF" ) ) 
            {
            return NO_STATE;
        }
        return value;
    }

    // Constructor
    protected function initialize( data as JsonObject ) {
        // First initialize the super class
        // We need the label from the super class before continuing
        SitemapElement.initialize( data );

        // For some elements, the label includes a state in the format:
        //   label [state]
        // We split the two, storing the actual label in the `label` member
        // and the state in `widgetState`.
        // In this case we do not use a "normalized" label member, because
        // the changed ("normalized") value should be also available where
        // the base class is used. 
        var normalizedLabel = normalizeLabel( label );
        label = normalizedLabel[0];
        widgetState = normalizeState( normalizedLabel[1] );

        // ... and then read all the elements
        var item = getItem( data );
        itemName =  getString( item, ITEM_NAME, "Element '" + label + "': item has no name" );

        itemType =  getString( item, ITEM_TYPE, "Element '" + label + "': item has no type" );
        if( itemType.equals( ITEM_TYPE_GROUP ) ) {
            normalizedItemType =  getString( item, ITEM_GROUP_TYPE, "Element '" + label + "': group has no type" );
        } else {
            normalizedItemType = itemType;
        }

        itemState = item[ITEM_STATE] as String?;
        normalizedItemState = normalizeState( itemState );

        if( normalizedItemType.equals( "Dimmer" ) ) {
            unit = "%";
        } else if( normalizedItemType.equals( "Rollershutter" ) ) {
            unit = "%";
        }
    }

    protected function getItem( data as JsonObject ) as JsonObject {
        return getObject( data, ITEM, "Element '" + label + "': no item found" );
    }
}