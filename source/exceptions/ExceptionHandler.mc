import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;

public class ExceptionHandler {


    private static var _hasCurrentSitemap as Boolean = false;
    public static function setHasCurrentSitemap( hasMenu as Boolean ) as Void { _hasCurrentSitemap = hasMenu; }
    
    public static function handleException( ex as Exception ) as Void {
        if( ex instanceof CommunicationException && _hasCurrentSitemap ) {
            WatchUi.showToast( 
                ex.getToastMessage().toUpper(), 
                { :icon => Rez.Drawables.iconWarning } );
        } else {
            ViewHandler.popToBottomAndSwitch( new ErrorView( ex ), null );
        }
    }

}