import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

enum ExceptionSource {
    EX_SOURCE_SITEMAP,
    EX_SOURCE_COMMAND
}

public class ExceptionHandler {
    private static const SOURCE_NAMES = [ "Sitemap", "Command" ];
    
    public static function getSourceName( source as ExceptionSource ) as String {
        return SOURCE_NAMES[source];
    }

    public static function handleException( ex as Exception ) as Void {
        if( ex instanceof CommunicationException ) {
            WatchUi.showToast( 
                ex.getSource().toUpper() + "\n" + ex.getToastMessage().toUpper(), 
                { :icon => Rez.Drawables.WarningIcon } );
        } else if( ex instanceof PushViewException ) {
            WatchUi.showToast( 
                "PAGE ERROR", 
                { :icon => Rez.Drawables.WarningIcon } );
        } else {
            ViewHandler.popToBottomAndSwitch( new ErrorView( ex ), null );
        }
    }

}