import Toybox.Lang;
import Toybox.WatchUi;

/**
 * Base class for all menu items representing `Switch` sitemap elements
 * that immediately update the associated openHAB item's state upon selection.
 *
 * This class is intended for switches where user interaction should directly
 * trigger a state change (e.g., ON/OFF).
 */
class BaseSwitchMenuItem extends BaseSitemapMenuItem {
    // The openHAB item linked to the sitemap element
    private var _itemName as String;
    public function getItemName() as String {
        return _itemName;
    }

    // The command request for sending commands
    // Defined as interface, since two types of command requests are supported
    private var _commandRequest as BaseCommandRequest?;

    // Abstract function to be implemented by subclasses.
    // getNextCommand() should return the command to be triggered
    // when the menu item is selected.
    // If it returns null, the menu item delegates command selection
    // to an asynchronous process, which is responsible for calling
    // sendCommand() directly.
    public function getNextCommand() as String? {
        throw new AbstractMethodException( "BaseSwitchMenuItem.getNextCommand" );
    }
    // updateItemState() shall update the state Drawable with a new state
    public function updateItemState( state as String ) as Void {
        throw new AbstractMethodException( "BaseSwitchMenuItem.updateItemState" );
    }
    
    // Constructor
    protected function initialize( sitemapSwitch as SitemapSwitch, statusDrawable as Drawable, isActionable as Boolean ) {
        _itemName = sitemapSwitch.itemName;
        BaseSitemapMenuItem.initialize(
            {
                :id => sitemapSwitch.id,
                :label => sitemapSwitch.label,
                :status => statusDrawable,
                :isActionable => isActionable
            }
        );
        
        _commandRequest = BaseCommandRequest.get( self );
    }


    // `onSelect()` retrieves the command from the subclass and sends it.
    // If getNextCommand() returns null, the menu item delegates command selection
    // to an asynchronous process, which is responsible for calling
    // sendCommand() directly.
    public function onSelect() as Void {
        if( _newState == null && _commandRequest != null ) {
            var command = getNextCommand();
            if( command != null ) {
                sendCommand( command );
            }
        }
    }
    
    // The new state is stored in `_newState` and only applied after the request succeeds.
    private var _newState as String?;
    // Send the command via the command request
    public function sendCommand( command as String ) as Void {
        _newState = command;
        if( _commandRequest != null ) {
            _commandRequest.sendCommand( command );
        }
    }

    // Called by the command request after the command is successfully sent.
    // Triggers `updateItemState()` for the subclass to update the state `Drawable`,
    // and then requests a UI redraw.
    public function onCommandComplete() as Void {
        if( _newState != null ) {
            updateItemState( _newState );
            _newState = null;
            WatchUi.requestUpdate();
        }
    }

    // Called by the command request if an error occurred.
    // The `_newState` will not be applied.
    public function onException( ex as Exception ) as Void {
        _newState = null;
    }

    // Called by the sitemap request when updated state data is received.
    // Updates the label and delegates status `Drawable` updates to the subclass.
    public function update( sitemapElement as SitemapElement ) as Boolean {
        var sitemapSwitch = sitemapElement as SitemapSwitch;
        // setLabel needs to come before updateItemState,
        // so that updateItemState can already access the
        // updated label
        setLabel( sitemapSwitch.label );
        updateItemState( sitemapSwitch.normalizedItemState );
        return true;
    }
}