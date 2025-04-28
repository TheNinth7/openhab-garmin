import Toybox.Lang;
import Toybox.WatchUi;

class OnOffMenuItem extends BaseMenuItem {
    private var _itemName as String;
    private var _isEnabled as Boolean;
    private var _statusDrawable as OnOffStatusDrawable;
    private var _commandRequest as CommandRequest?;

    public static const ITEM_TYPE = "Switch";

    private function parseItemState( itemState as String ) as Boolean {
        return itemState.equals( SitemapSwitch.ITEM_STATE_ON );
    }

    public function initialize( sitemapSwitch as SitemapSwitch ) {
        _isEnabled = parseItemState( sitemapSwitch.itemState );
        _statusDrawable = new OnOffStatusDrawable( _isEnabled );

        BaseMenuItem.initialize(
            sitemapSwitch,
            {
                :label => sitemapSwitch.label,
                :status => _statusDrawable
            }
        );
        _itemName = sitemapSwitch.itemName;
        if( AppSettings.canSendCommands() ) {
            _commandRequest = new CommandRequest( self );
        }
    }

    public function isEnabled() as Boolean { return _isEnabled; }
    public function setEnabled( isEnabled as Boolean ) as Void { 
        _isEnabled = isEnabled; 
        _statusDrawable.setEnabled( isEnabled );
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
            _newState = ! isEnabled();
            ( _commandRequest as CommandRequest ).sendCommand( _newState ? "ON" : "OFF" );
        }
        //setEnabled( ! isEnabled() );
    }
    public function onCommandComplete() as Void {
        if( _newState != null ) {
            setEnabled( _newState );
            _newState = null;
            WatchUi.requestUpdate();
        }
    }

    public function update( sitemapSwitch as SitemapSwitch ) as Boolean {
        setCustomLabel( sitemapSwitch.label );
        setEnabled( parseItemState( sitemapSwitch.itemState ) );
        return true;
    }
}

class OnOffStatusDrawable extends Text {
    public function initialize( isEnabled as Boolean ) {
        Text.initialize( {
            :text => getStatusText( isEnabled ),
            :font => Graphics.FONT_SMALL,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        } );
    }
    public function setEnabled( isEnabled as Boolean ) as Void {
        setText( getStatusText( isEnabled ) );
    }
    private function getStatusText( isEnabled as Boolean ) as String {
        return isEnabled ? "ON" : "OFF";
    }
}