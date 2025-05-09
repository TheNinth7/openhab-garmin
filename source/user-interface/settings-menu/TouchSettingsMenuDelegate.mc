import Toybox.Lang;
import Toybox.WatchUi;

(:exclForButton)
class TouchSettingsMenuDelegate extends BaseSettingsMenuDelegate {
    public function initialize() {
        BaseSettingsMenuDelegate.initialize();
    }

    public function onBack() as Void {
        SettingsMenuHandler.hideSettings( WatchUi.SLIDE_RIGHT );
    }

}