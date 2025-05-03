import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class SettingsMenuDelegate extends PageMenuDelegate {
    public function initialize() {
        PageMenuDelegate.initialize();
    }

    public function onSelect( item as MenuItem ) as Void {
    }

    public function onWrap( key as WatchUi.Key ) as Lang.Boolean {
        return false;
    }

    public function onNextPage() as Boolean {
        SettingsMenuHandler.hideSettings( WatchUi.SLIDE_UP );
        return true;
    }

    public function onPreviousPage() as Boolean {
        SettingsMenuHandler.hideSettings( WatchUi.SLIDE_DOWN );
        return true;
    }
}