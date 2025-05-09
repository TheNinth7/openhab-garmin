import Toybox.Lang;
import Toybox.WatchUi;

/*
    This (static) Singleton class tracks whether currently toasts
    shall be displayed, and provides a function for displaying toasts
*/
public class ToastHandler {
    private static var _useToasts as Boolean = true;
    // Views should call this function in their onShow() to indicate
    // whether they want toasts to display. Views shall NOT change
    // this in onHide(). This allows subsequent views to inherit the
    // state of the previous view. For example for the menus, only
    // HomepageMenu needs to set it, all subsequent views inherit it
    public static function setUseToasts( useToasts as Boolean ) as Void { 
        _useToasts = useToasts; 
    }

    // Indicates whether the current view wants toasts
    // The actual logic deciding whether a toast will be displayed is
    // in the ExceptionHandler, since there are more factors to take
    // into account than only the indication of the view
    public static function useToasts() as Boolean { 
        return _useToasts; 
    }

    // Show a warning toast
    public static function showWarning( warning as String ) as Void {
        WatchUi.showToast( 
            warning.toUpper(), 
            { :icon => Rez.Drawables.iconWarning } );
    }
}
