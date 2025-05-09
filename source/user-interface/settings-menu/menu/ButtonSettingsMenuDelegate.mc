import Toybox.Lang;
import Toybox.WatchUi;

/*
    This is the input delegate for the settings menu on
    button-based devices.
    For such devices the settings menu is a parallel menu to the
    homepage menu. 
    
    The footer of the homepage menu shows a settings
    icon, and scrolling over the last menu entry opens the settings
    menu, focused on its first item. Also scrolling up over the first menu entry 
    in the homepage menu opens the settings menu, but focused on the
    last entry.

    Analogue to that, leaving the settings menu by scrolling up over
    the first item opens the homepage menu, focused on its last item.
    Leaving the settings menu by scrolling down over its last item
    opens the homepage menu, focused on its first item.

    So while it is two different menu views, they behave as one menu
    consisting of both the homepage menu items and the settings menu 
    items.

    This delegate handles the transitions from the settings menu to
    the homepage menu.
*/
(:exclForTouch)
class ButtonSettingsMenuDelegate extends BaseSettingsMenuDelegate {
    public function initialize() {
        BaseSettingsMenuDelegate.initialize();
    }

    // When leaving the menu by scrolling down, hide the settings with
    // SLIDE_UP transition. The transition also tells the
    // SettingsMenuHandler which menu item to focus on in
    // the homepage menu
    public function onNextPage() as Boolean {
        SettingsMenuHandler.hideSettings( WatchUi.SLIDE_UP );
        return true;
    }

    // Same as above, but for leaving the settings menu by scrolling up
    public function onPreviousPage() as Boolean {
        SettingsMenuHandler.hideSettings( WatchUi.SLIDE_DOWN );
        return true;
    }

    // Back button triggers the same behavior as when scrolling up
    public function onBack() as Void {
        onPreviousPage();
    }

    // The behavior delegates above are only available
    // from CIQ 5.1.0 onwards. For older devices we
    // use the onWrap() handler, which triggers
    // whenever the menu is scrolled beyond the first
    // or last item. From the key we can determine which
    // way it was.
    // This however DOES NOT work for touch input, therefore
    // the use of the behavior delegates above is prefered if
    // they are available
    (:exclForCiq510Plus)
    public function onWrap( key as Key ) as Boolean {
        if( key == KEY_DOWN ) {
            onNextPage();
        } else if( key == KEY_UP ) {
            onPreviousPage();
        }
        // Returning false indicates to the system that
        // it should not scroll to the opposite end
        // of the menu
        return false;
    }
}