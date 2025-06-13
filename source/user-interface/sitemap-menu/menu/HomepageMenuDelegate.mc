import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

/*
 * `HomepageMenuDelegate` is a subclass of `PageMenuDelegate` that provides 
 * additional input handling specific to the homepage on button-based devices, 
 * such as accessing the settings menu.
 *
 * As it is only needed once, it is implemented as a singleton.
 */
class HomepageMenuDelegate extends PageMenuDelegate {
    // Singleton accessor
    private static var _instance as HomepageMenuDelegate?;
    public static function get() as HomepageMenuDelegate {
        if( _instance == null ) {
            _instance = new HomepageMenuDelegate();
        }
        return _instance as HomepageMenuDelegate;
    }

    // Constructor
    private function initialize() {
        PageMenuDelegate.initialize();
    }

    /*
    * On button-based devices, event handlers trigger the opening of the settings menu.
    * The `slideType` indicates which settings menu item should be focused.
    *
    * - Scrolling down past the last item triggers `onNextPage()`: the settings menu slides in from the bottom, 
    *   and the first settings item is focused.
    * - Scrolling up past the first item triggers `onPreviousPage()`: the settings menu slides in from the top, 
    *   and the last settings item is focused.
    */
    (:exclForTouch)
    public function onNextPage() as Boolean {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_UP );
        return true;
    }
    (:exclForTouch)
    public function onPreviousPage() as Boolean {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_DOWN );
        return true;
    }
    // Button-based devices may also have touch screens. 
    // For those, tapping the footer should behave the same as scrolling down.
    (:exclForTouch)
    public function onFooter() as Void {
        onNextPage();
    }

    /*
    * `onPreviousPage()` and `onNextPage()` are only available on devices running CIQ 5.1.0 or later.
    * For older versions, equivalent behavior can be implemented using `onWrap()` for button-based scrolling.
    *
    * However, since button-based devices may also have touch screens, 
    * using `onPreviousPage()` and `onNextPage()` is preferred when supported,
    * as they also work with swipe gestures.
    */
    (:exclForCiq510Plus :exclForTouch)
    public function onWrap( key as Key ) as Boolean {
        if( key == KEY_DOWN ) {
            onNextPage();
        } else if( key == KEY_UP ) {
            onPreviousPage();
        }
        return false;
    }

    // The base class uses ViewHandler.popView, which is
    // protected against leaving the homepage (=root) menu
    // Therefore here we override onBack and use the
    // standard popView()
    public function onBack() as Void {
        Logger.debug( "HomepageMenuDelegate.onBack" );
        WatchUi.popView( WatchUi.SLIDE_RIGHT );
    }
}