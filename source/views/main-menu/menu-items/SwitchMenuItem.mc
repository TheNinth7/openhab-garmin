import Toybox.Lang;
import Toybox.WatchUi;

class SwitchMenuItem extends BaseSitemapMenuItem {
    private var _itemName as String;
    private var _commandRequest as CommandRequest?;

    public function getNextCommand() as String {
        throw new AbstractMethodException( "SwitchMenuItem.getNextCommand" );
    }
    public function updateItemState( state as String ) as Void {
        throw new AbstractMethodException( "SwitchMenuItem.updateItemState" );
    }
    
    protected function initialize( sitemapSwitch as SitemapSwitch, statusDrawable as Drawable ) {
        _itemName = sitemapSwitch.itemName;
        BaseSitemapMenuItem.initialize(
            {
                :id => sitemapSwitch.id,
                :label => sitemapSwitch.label,
                :status => statusDrawable
            }
        );
        if( AppSettings.canSendCommands() ) {
            _commandRequest = new CommandRequest( self );
        }
    }

    public function getItemName() as String {
        return _itemName;
    }

    private var _newState as String?;
    public function onSelect() as Void {
        if( _newState == null && _commandRequest != null ) {
            _newState = getNextCommand();
            ( _commandRequest as CommandRequest ).sendCommand( _newState );
        }
    }
    
    public function onCommandComplete() as Void {
        if( _newState != null ) {
            updateItemState( _newState );
            _newState = null;
            WatchUi.requestUpdate();
        }
    }

    public function update( sitemapElement as SitemapElement ) as Boolean {
        var sitemapSwitch = sitemapElement as SitemapSwitch;
        setCustomLabel( sitemapSwitch.label );
        updateItemState( sitemapSwitch.itemState );
        return true;
    }
}
