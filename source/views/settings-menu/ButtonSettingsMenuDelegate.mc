import Toybox.Lang;

(:exclForTouch)
class ButtonSettingsMenuDelegate extends BaseSettingsMenuDelegate {
    public function initialize() {
        BaseSettingsMenuDelegate.initialize();
    }

    public function onNextPage() as Boolean {
        SettingsMenuHandler.hideSettings( WatchUi.SLIDE_UP );
        return true;
    }

    public function onPreviousPage() as Boolean {
        SettingsMenuHandler.hideSettings( WatchUi.SLIDE_DOWN );
        return true;
    }

    public function onBack() as Void {
        onPreviousPage();
    }

    (:exclForCiq510Plus)
    public function onWrap( key as Key ) as Boolean {
        if( key == KEY_DOWN ) {
            onNextPage();
        } else if( key == KEY_UP ) {
            onPreviousPage();
        }
        return false;
    }
}