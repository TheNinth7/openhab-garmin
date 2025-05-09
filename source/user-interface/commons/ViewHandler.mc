import Toybox.Lang;
import Toybox.WatchUi;

/*
    The ViewHandler must be used all across the app for switching
    views or popping/pushing them from/to the stack.

    The main purpose is that we need to keep track of how many views
    are on the stack, in case due to an update or error we need to 
    pop all views and switch to the homepage or error view.
*/
class ViewHandler {
    // Counter for views on top of the base view
    // 0 = there is only one base view on the stack
    // 1 = there are two views, ...
    private static var _stackSize as Number = 0;

    // Push/pop a view on/from the stack
    public static function pushView( view as Views, delegate as InputDelegates or Null, transition as SlideType ) as Void {
        WatchUi.pushView( view, delegate, transition );
        _stackSize++;
        // Logger.debug( "ViewHandler.pushView: stack size=" + _stackSize );
    }
    public static function popView( transition as SlideType ) as Void {
        _stackSize--;
        WatchUi.popView( transition );
        // Logger.debug( "ViewHandler.popView: stack size=" + _stackSize );
    }

    // Remove all views from the stack except the base
    // view, and replace the base view by the view passed in
    // as parameter.
    public static function popToBottomAndSwitch( view as Views, delegate as InputDelegates or Null ) as Void {
        // Logger.debug( "ViewHandler.popToBottomAndSwitch: initial stack size=" + _stackSize );
        for( var i = 0; i < _stackSize; i++ ) {
            WatchUi.popView( WatchUi.SLIDE_IMMEDIATE );
            _stackSize--;
        }
        // Logger.debug( "ViewHandler.popToBottomAndSwitch: final stack size=" + _stackSize );
        WatchUi.switchToView( view, delegate, WatchUi.SLIDE_BLINK );
    }
}