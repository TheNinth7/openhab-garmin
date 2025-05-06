import Toybox.Lang;
import Toybox.WatchUi;

(:exclForButton)
class SettingsMenuItem extends BaseSitemapMenuItem {
    public function initialize() {
        BaseSitemapMenuItem.initialize( { 
            :id => "__settings__",
            :icon => Rez.Drawables.menuSettings,
            :label => "Settings",
            :labelColor => Graphics.COLOR_LT_GRAY
        } );
    }

    public function onSelect() as Void {
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_LEFT );
    }
}