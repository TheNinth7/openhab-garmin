import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

/*
    Base class for the input delegate of the settings menu.
    There are two derived delegates, one for button devices,
    and one for touch devices.
    Currently there is no logic here, but in future if onSelect
    is needed, the logic should be implemented here since it applies
    to both.
*/
class BaseSettingsMenuDelegate extends PageMenuDelegate {
    protected function initialize() {
        PageMenuDelegate.initialize();
    }

    public function onSelect( item as MenuItem ) as Void {
    }
}