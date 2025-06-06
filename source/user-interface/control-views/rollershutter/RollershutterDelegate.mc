import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Delegate responsible for processing user input in the full-screen
 * `RollershutterView`. Maintains a reference to the associated
 * `RollershutterMenuItem`, which it uses to send commands and update the view.
 */
class RollershutterDelegate extends CustomBehaviorDelegate {

    // The menu item that opened this view
    private var _menuItem as RollershutterMenuItem;

    // Constructor
    public function initialize( menuItem as RollershutterMenuItem ) {
        CustomBehaviorDelegate.initialize();
        _menuItem = menuItem;
    }

    // React to touch area events defined in `RollershutterView`
    public function onAreaTap( area as Symbol, clickEvent as ClickEvent ) as Boolean {
        // Logger.debug "CustomPickerDelegate.onAreaTap" );
        if( area == :touchUp ) {
            return onUp();
        } else if( area == :touchDown ) {
            return onDown();
        } else if( area == :touchStop ) {
            return onStop();
        }
        return false;
    }

    // This delegate function covers both the back key
    // and the swipe right gesture
    public function onBack() as Boolean {
        _menuItem.onReturn();
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
        return true;
    }

    // Internal function called by the key/touch delegates
    // to issue the down command
    private function onDown() as Boolean {
        _menuItem.sendCommand( SwitchItem.ITEM_STATE_DOWN );
        return true;
    }

    // React to key presses
    public function onKey( keyEvent as KeyEvent ) as Boolean {
        // Logger.debug( "CustomPickerDelegate.onKey: start" );
        var key = keyEvent.getKey();
        if( key == KEY_ENTER ) {
            return onStop();
        } else if( key == KEY_UP ) {
            return onUp();
        } else if( key == KEY_DOWN ) {
            return onDown();
        }
        // Logger.debug( "CustomPickerDelegate.onKey: end" );
        return false;
    }

    // Internal function called by the key/touch delegates
    // to issue the stop command
    private function onStop() as Boolean {
        _menuItem.sendCommand( SwitchItem.ITEM_STATE_STOP );
        return true;
    }

    // Internal function called by the key/touch delegates
    // to issue the up command
    private function onUp() as Boolean {
        _menuItem.sendCommand( SwitchItem.ITEM_STATE_UP );
        return true;
    }
}