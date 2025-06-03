import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A menu item that displays an on/off switch as its status.
 * Selecting the item toggles the switch state.
 */
class OnOffSwitchMenuItem extends BaseSwitchMenuItem {

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return 
               sitemapWidget instanceof SitemapSwitch 
            && ! sitemapWidget.hasMappings()
            && sitemapWidget.item.hasState();
    }

    // True if the switch is on
    private var _isEnabled as Boolean;
    // The actual Drawable for drawing the switch
    private var _statusDrawable as OnOffStatusDrawable;

    // Strings representing the on/off state in the sitemap state
    private static const ITEM_STATE_ON = "ON";
    private static const ITEM_STATE_OFF = "OFF";

    // Toggle the state
    public function getNextCommand() as String? {
        return _isEnabled ? ITEM_STATE_OFF : ITEM_STATE_ON;
    }
    // Update the member and Drawable
    public function updateItemState( state as String ) as Void {
        _isEnabled = parseItemState( state );
        _statusDrawable.setEnabled( _isEnabled );
    }

    // Converts the string state to a Boolean for _isEnabled
    // ON => true; OFF => false
    private function parseItemState( itemState as String? ) as Boolean {
        if( ITEM_STATE_ON.equals( itemState ) ) {
            return true;            
        } else if( ITEM_STATE_OFF.equals( itemState ) ) {
            return false;
        } else {
            throw new GeneralException( "OnOffSwitchMenuItem: state '" + itemState + "' is not supported" );
        }
    }

    // Constructor
    public function initialize( sitemapSwitch as SitemapSwitch ) {
        var itemState = sitemapSwitch.item.state;
        if( ! ( itemState.equals( ITEM_STATE_ON ) || itemState.equals( ITEM_STATE_OFF ) ) ) {      
            throw new JsonParsingException( "Switch '" + sitemapSwitch.label + "': invalid state '" + itemState + "'" );
        }
        _isEnabled = parseItemState( sitemapSwitch.item.state );
        _statusDrawable = new OnOffStatusDrawable( _isEnabled );
        BaseSwitchMenuItem.initialize( sitemapSwitch, _statusDrawable, false );
    }
}