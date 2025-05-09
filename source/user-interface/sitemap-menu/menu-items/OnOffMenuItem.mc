import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class OnOffMenuItem extends SwitchMenuItem {
    private var _isEnabled as Boolean;
    private var _statusDrawable as OnOffStatusDrawable;

    private static const ITEM_STATE_ON = "ON";
    private static const ITEM_STATE_OFF = "OFF";

    public static const ITEM_TYPE = "Switch";

    public function getNextCommand() as String {
        return _isEnabled ? ITEM_STATE_OFF : ITEM_STATE_ON;
    }
    public function updateItemState( state as String ) as Void {
        _isEnabled = parseItemState( state );
        _statusDrawable.setEnabled( _isEnabled );
    }

    private function parseItemState( itemState as String ) as Boolean {
        if( itemState.equals( ITEM_STATE_ON ) ) {
            return true;            
        } else if( itemState.equals( ITEM_STATE_OFF ) ) {
            return false;
        } else {
            throw new GeneralException( "OnOffMenuItem: state '" + itemState + "' is not supported" );
        }
    }

    public function initialize( sitemapSwitch as SitemapSwitch ) {
        var itemState = sitemapSwitch.itemState;
        if( ! ( itemState.equals( ITEM_STATE_ON ) || itemState.equals( ITEM_STATE_OFF ) ) ) {      
            throw new JsonParsingException( "Switch '" + sitemapSwitch.label + "': invalid state '" + itemState + "'" );
        }
        _isEnabled = parseItemState( sitemapSwitch.itemState );
        _statusDrawable = new OnOffStatusDrawable( _isEnabled );
        SwitchMenuItem.initialize( sitemapSwitch, _statusDrawable );
    }

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return 
               sitemapElement instanceof SitemapSwitch 
            && sitemapElement.itemType.equals( ITEM_TYPE );
    }

}