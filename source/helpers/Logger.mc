import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.System;

(:glance)
public class Logger {

    // Info should be used in places where the output shall remain
    // permanent part of the code. As opposed to temporary debug
    // statements that may be commented in/out as needed for debugging
    public static function info( text as String ) as Void {
        debug( text );
    }

    // Output a debug statement
    (:debug) 
    public static function debug( text as String ) as Void {
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$4$.$5$.$6$ $1$:$2$:$3$",
            [
                now.hour,
                now.min,
                now.sec,
                now.day,
                now.month,
                now.year
            ] );
        System.println( dateString + ": " + text );
    }

    // Output the content of an exception
    (:debug) 
    public static function debugException( ex as Exception ) as Void {
        var errorMsg = ex.getErrorMessage();
        if( errorMsg != null ) {
            debug( errorMsg );
        }
        ex.printStackTrace();
        System.println(" ");
    }
  
    // For release builds, there shall be no debug output
    (:release) public static function debug( text as String ) as Void {}
    (:release) public static function debugException( ex as Exception ) as Void {}


}