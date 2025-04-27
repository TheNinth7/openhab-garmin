import Toybox.Lang;
import Toybox.WatchUi;

class ViewHandler {
    private static var _stackSize as Number = 0;
    public static function pushView( view as Views, delegate as InputDelegates or Null, transition as SlideType ) as Boolean {
        _stackSize++;
        return WatchUi.pushView( view, delegate, transition );
    }
    public static function popView( transition as SlideType ) as Void {
        _stackSize--;
        WatchUi.popView( transition );
    }

    public static function popToBottomAndSwitch( view as Views, delegate as InputDelegates or Null ) as Void {
        for( var i = 0; i < _stackSize; i++ ) {
            WatchUi.popView( WatchUi.SLIDE_IMMEDIATE );
        }
        WatchUi.switchToView( view, delegate, WatchUi.SLIDE_IMMEDIATE );
    }

}