import Toybox.Lang;
import Toybox.WatchUi;

class SwitchMenuItem extends ToggleMenuItem {

    private var _itemName as String;
    private var _commandRequest as CommandRequest?;

    public function initialize( sitemapSwitch as SitemapSwitch ) {
        ToggleMenuItem.initialize(
            sitemapSwitch.label,
            null,
            sitemapSwitch.id, // identifier
            sitemapSwitch.isEnabled,
            null
        );
        _itemName = sitemapSwitch.itemName;
        if( AppSettings.canSendCommands() ) {
            _commandRequest = new CommandRequest( self );
        }
    }

    public function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return sitemapElement instanceof SitemapSwitch;
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
        setEnabled( sitemapSwitch.isEnabled );
        return true;
    }
}