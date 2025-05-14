import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Input delegate for the action menu of a GenericSwitchMenuItem.
 *
 * The action menu allows the user to select a command to send.
 * Once a command is selected, this delegate sends it via the
 * associated menu item.
 */
class GenericSwitchActionMenuDelegate extends ActionMenuDelegate {

    var _menuItem as GenericSwitchMenuItem;

    // Constructor
    public function initialize( menuItem as GenericSwitchMenuItem ) {
        ActionMenuDelegate.initialize();
        _menuItem = menuItem;
    }

    // on select, send the command
    public function onSelect( item as ActionMenuItem ) as Void {
        Logger.debug( "GenericSwitchActionMenuDelegate.onSelect" );
        // The action menu items have the command as Id
        var command = item.getId();
        if( command instanceof String ) {
            _menuItem.sendCommand( command );
        } else {
            throw new GeneralException( "GenericSwitchActionMenuDelegate: invalid command" );
        }
    }
}