import Toybox.Lang;
import Toybox.WatchUi;

/*
    For touch devices the approach of having the settings menu as
    parallel menu under the homepage menu is less intuitive. Therefore,
    instead the settings menu is presented as menu item unter the
    homepage menu.

    For this, the input delegate only needs to implement the onBack()
    behavior.
*/
(:exclForButton)
class TouchSettingsMenuDelegate extends BaseSettingsMenuDelegate {
    public function initialize() {
        BaseSettingsMenuDelegate.initialize();
    }

    public function onBack() as Void {
        SettingsMenuHandler.hideSettings( WatchUi.SLIDE_RIGHT );
    }
}