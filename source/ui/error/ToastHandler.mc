import Toybox.Lang;
import Toybox.WatchUi;

public class ToastHandler {
    private static var _useToasts as Boolean = true;
    public static function useToasts() as Boolean { 
        return _useToasts; 
    }
    public static function setUseToasts( useToasts as Boolean ) as Void { 
        _useToasts = useToasts; 
    }

    public static function showWarning( warning as String ) as Void {
        WatchUi.showToast( 
            warning.toUpper(), 
            { :icon => Rez.Drawables.iconWarning } );
    }
}
