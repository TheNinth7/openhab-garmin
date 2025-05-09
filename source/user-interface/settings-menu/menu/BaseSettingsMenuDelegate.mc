import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

/*
 * Base class for the input delegate of the settings menu.
 *
 * There are two derived delegates: one for button-based devices 
 * and one for touch-based devices.
 *
 * Currently, this class contains no logic. However, if shared behavior 
 * such as `onSelect` is needed in the future, it should be implemented here, 
 * as it would apply to both device types.
 */
class BaseSettingsMenuDelegate extends PageMenuDelegate {
    protected function initialize() {
        PageMenuDelegate.initialize();
    }

    public function onSelect( item as MenuItem ) as Void {
    }
}