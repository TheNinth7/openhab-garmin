import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;

public class ExceptionHandler {

    private static const FATAL_ERROR_COUNT = 3;

    private static var _useToasts as Boolean = false;
    public static function setUseToasts( useToasts as Boolean ) as Void { 
        _useToasts = useToasts; 
    }

    private static var _comErrorCount as Number = 0;
    public static function resetCommunicationErrorCount() as Void {
        Logger.debug( "ExceptionHandler: reset of error count");   
        _comErrorCount = 0;
    }
    public static function getCommunicationErrorCount() as Number {
        return _comErrorCount;
    }
        
    public static function handleException( ex as Exception ) as Void {
        Logger.debugException( ex );
        if( ex instanceof CommunicationBaseException 
            && !ex.isFatal()
            && _useToasts
            && _comErrorCount < FATAL_ERROR_COUNT-1 ) {
            _comErrorCount++;
            Logger.debug( "ExceptionHandler: showing toast" );
            WatchUi.showToast( 
                ex.getToastMessage().toUpper(), 
                { :icon => Rez.Drawables.iconWarning } );
        } else {
            Logger.debug( "ExceptionHandler: showing error view" );
            ViewHandler.popToBottomAndSwitch( new ErrorView( ex ), null );
            _useToasts = false;
        }
    }
}