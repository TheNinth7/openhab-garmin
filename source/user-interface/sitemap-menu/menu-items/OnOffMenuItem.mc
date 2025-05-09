import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A menu item that displays an on/off switch as its status.
 * Selecting the item toggles the switch state.
 */
class OnOffMenuItem extends SwitchMenuItem {
    // True if the switch is on
    private var _isEnabled as Boolean;
    // The actual Drawable for drawing the switch
    private var _statusDrawable as OnOffStatusDrawable;

    // Strings representing the on/off state in the sitemap state
    private static const ITEM_STATE_ON = "ON";
    private static const ITEM_STATE_OFF = "OFF";

    // This menu item applies to all sitemap elements of type Switch
    // that are associated with an openHAB item of type Switch
    public static const ITEM_TYPE = "Switch";

    // Toggle the state
    public function getNextCommand() as String {
        return _isEnabled ? ITEM_STATE_OFF : ITEM_STATE_ON;
    }
    // Update the member and Drawable
    public function updateItemState( state as String ) as Void {
        _isEnabled = parseItemState( state );
        _statusDrawable.setEnabled( _isEnabled );
    }

    // Converts the string state to a Boolean for _isEnabled
    // ON => true; OFF => false
    private function parseItemState( itemState as String ) as Boolean {
        if( itemState.equals( ITEM_STATE_ON ) ) {
            return true;            
        } else if( itemState.equals( ITEM_STATE_OFF ) ) {
            return false;
        } else {
            throw new GeneralException( "OnOffMenuItem: state '" + itemState + "' is not supported" );
        }
    }

    // Constructor
    public function initialize( sitemapSwitch as SitemapSwitch ) {
        var itemState = sitemapSwitch.itemState;
        if( ! ( itemState.equals( ITEM_STATE_ON ) || itemState.equals( ITEM_STATE_OFF ) ) ) {      
            throw new JsonParsingException( "Switch '" + sitemapSwitch.label + "': invalid state '" + itemState + "'" );
        }
        _isEnabled = parseItemState( sitemapSwitch.itemState );
        _statusDrawable = new OnOffStatusDrawable( _isEnabled );
        SwitchMenuItem.initialize( sitemapSwitch, _statusDrawable );
    }

    // Used during updates to check if a sitemap element matches this menu item type.
    // If so, the item is updated; otherwise, it is replaced.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return 
               sitemapElement instanceof SitemapSwitch 
            && sitemapElement.itemType.equals( ITEM_TYPE );
    }
}