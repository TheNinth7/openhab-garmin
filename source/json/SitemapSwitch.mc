import Toybox.Lang;
import Toybox.WatchUi;

class SitemapSwitch extends SitemapElement {

    private const ITEM = "item";
    private const ITEM_NAME = "name";
    private const ITEM_TYPE = "type";
    private const ITEM_STATE = "state";
    public static const ITEM_STATE_ON = "ON";
    public static const ITEM_STATE_OFF = "OFF";

    public var itemName as String;
    public var itemState as String;
    public var itemType as String;
    
    function initialize( data as JsonObject ) {
        SitemapElement.initialize( data );
        var item = getObject( data, ITEM, "Switch '" + label + "': no item found" );
        itemName = getString( item, ITEM_NAME, "Switch '" + label + "': item has no name" );
        itemType = getString( item, ITEM_TYPE, "Switch '" + label + "': item has no type" );
        itemState = getString( item, ITEM_STATE, "Switch '" + label + "': item has no state" );
        if( itemType.equals( OnOffMenuItem.ITEM_TYPE ) ) {
            if( ! ( itemState.equals( ITEM_STATE_ON ) || itemState.equals( ITEM_STATE_OFF ) ) ) {      
                throw new JsonParsingException( "Switch '" + label + "': invalid state '" + itemState + "'" );
            }
        } else {
            throw new JsonParsingException( "Switch '" + label + "': unsupported item type '" + itemType + "'" );
        }
    }
}