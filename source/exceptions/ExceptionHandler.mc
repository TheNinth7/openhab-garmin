import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;

enum ExceptionSource {
    EX_SOURCE_SITEMAP,
    EX_SOURCE_COMMAND
}

public class ExceptionHandler {

    private static const SOURCE_NAMES = [ "Sitemap", "Command" ];
    private static const SOURCE_SHORTCODE = [ "S", "C" ];
    public static function getSourceName( source as ExceptionSource ) as String {
        return SOURCE_NAMES[source];
    }
    public static function getSourceShortCode( source as ExceptionSource ) as String {
        return SOURCE_SHORTCODE[source];
    }

    private static var _hasCurrentSitemap as Boolean = false;
    public static function setHasCurrentSitemap( hasMenu as Boolean ) as Void { _hasCurrentSitemap = hasMenu; }
    
    public static function handleException( ex as Exception ) as Void {
        if( ex instanceof CommunicationException && _hasCurrentSitemap ) {
            WatchUi.showToast( 
                ex.getToastMessage().toUpper(), 
                { :icon => Rez.Drawables.WarningIcon } );
        } else {
            ViewHandler.popToBottomAndSwitch( new ErrorView( ex ), null );
        }
    }

}