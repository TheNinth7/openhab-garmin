import Toybox.Lang;
import Toybox.WatchUi;

class ViewHandler {
    private static var _stackSize as Number = 0;
    public static function pushView( view as Views, delegate as InputDelegates or Null, transition as SlideType ) as Void {
        WatchUi.pushView( view, delegate, transition );
        _stackSize++;
        Logger.debug( "ViewHandler.pushView: stack size=" + _stackSize );
    }

    public static function popView( transition as SlideType ) as Void {
        _stackSize--;
        WatchUi.popView( transition );
        Logger.debug( "ViewHandler.popView: stack size=" + _stackSize );
    }

    public static function popToBottomAndSwitch( view as Views, delegate as InputDelegates or Null ) as Void {
        Logger.debug( "ViewHandler.popToBottomAndSwitch: initial stack size=" + _stackSize );
        for( var i = 0; i < _stackSize; i++ ) {
            WatchUi.popView( WatchUi.SLIDE_IMMEDIATE );
            _stackSize--;
        }
        Logger.debug( "ViewHandler.popToBottomAndSwitch: final stack size=" + _stackSize );
        WatchUi.switchToView( view, delegate, WatchUi.SLIDE_BLINK );
    }
}