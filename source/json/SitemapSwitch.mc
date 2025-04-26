import Toybox.Lang;
import Toybox.WatchUi;

class SitemapSwitch extends SitemapElement {

    private const LABEL = "label";
    private const ITEM = "item";
    private const ITEM_NAME = "name";
    private const ITEM_STATE = "state";
    private const ITEM_STATE_ON = "ON";
    private const ITEM_STATE_OFF = "OFF";

    public var label as String;
    public var itemName as String;
    public var isEnabled as Boolean;

    function initialize( data as JsonObject ) {
        SitemapElement.initialize();
        label = getString( data, LABEL, "Switch: no label found!" );
        var item = getObject( data, ITEM, "Switch '" + label + "': no item found!" );
        itemName = getString( item, ITEM_NAME, "Switch '" + label + "': item has no name!" );
        var itemState = getString( item, ITEM_STATE, "Switch '" + label + "': item has no state!" );
        if( ! ( itemState.equals( ITEM_STATE_ON ) || itemState.equals( ITEM_STATE_OFF ) ) ) {      
            throw new JsonParsingException( "Switch '" + label + "': invalid state '" + itemState + "'!" );
        }
        isEnabled = itemState.equals( ITEM_STATE_ON );
    }
}