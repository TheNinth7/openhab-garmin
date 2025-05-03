import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class HomepageMenuDelegate extends PageMenuDelegate {
    public function initialize() {
        PageMenuDelegate.initialize();
    }

    public function onNextPage() as Boolean {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_UP );
        return true;
    }

    public function onFooter() as Void {
        onNextPage();
    }

    public function onPreviousPage() as Boolean {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_DOWN );
        return true;
    }
}