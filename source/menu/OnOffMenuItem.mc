import Toybox.Lang;
import Toybox.WatchUi;

class OnOffMenuItem extends ToggleMenuItem {

    private var _itemName as String;
    private var _commandRequest as CommandRequest?;

    public static const ITEM_TYPE = "Switch";

    public function initialize( sitemapSwitch as SitemapSwitch ) {
        ToggleMenuItem.initialize(
            sitemapSwitch.label,
            null,
            sitemapSwitch.id, // identifier
            sitemapSwitch.isOn(),
            null
        );
        _itemName = sitemapSwitch.itemName;
        if( AppSettings.canSendCommands() ) {
            _commandRequest = new CommandRequest( self );
        }
    }

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return 
               sitemapElement instanceof SitemapSwitch 
            && sitemapElement.itemType.equals( ITEM_TYPE );
    }

    public function getItemName() as String {
        return _itemName;
    }

    private var _newState as Boolean?;
    public function processStateChange() as Void {
        if( _newState == null && _commandRequest != null ) {
            _newState = isEnabled();
            ( _commandRequest as CommandRequest ).sendCommand( _newState ? "ON" : "OFF" );
        }
        setEnabled( ! isEnabled() );
    }
    public function onCommandComplete() as Void {
        if( _newState != null ) {
            setEnabled( _newState );
            _newState = null;
            WatchUi.requestUpdate();
        }
    }

    public function update( sitemapSwitch as SitemapSwitch ) as Boolean {
        setLabel( sitemapSwitch.label );
        setEnabled( sitemapSwitch.isOn() );
        return true;
    }
}