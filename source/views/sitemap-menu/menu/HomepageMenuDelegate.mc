import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class HomepageMenuDelegate extends PageMenuDelegate {
    private function initialize() {
        PageMenuDelegate.initialize();
    }
    private static var _instance as HomepageMenuDelegate?;
    public static function get() as HomepageMenuDelegate {
        if( _instance == null ) {
            _instance = new HomepageMenuDelegate();
        }
        return _instance as HomepageMenuDelegate;
    }

    (:exclForTouch)
    public function onNextPage() as Boolean {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_UP );
        return true;
    }

    (:exclForTouch)
    public function onFooter() as Void {
        onNextPage();
    }

    (:exclForTouch)
    public function onPreviousPage() as Boolean {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_DOWN );
        return true;
    }

    (:exclForCiq510Plus :exclForTouch)
    public function onWrap( key as Key ) as Boolean {
        if( key == KEY_DOWN ) {
            onNextPage();
        } else if( key == KEY_UP ) {
            onPreviousPage();
        }
        return false;
    }
}