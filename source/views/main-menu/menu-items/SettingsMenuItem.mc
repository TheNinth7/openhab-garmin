import Toybox.Lang;
import Toybox.WatchUi;

(:exclForButton)
class SettingsMenuItem extends BaseViewMenuItem {
    public function initialize( parentMenu as CustomMenu ) {
        BaseViewMenuItem.initialize( { 
            :parentMenu => parentMenu,
            :id => "__settings__",
            :icon => Rez.Drawables.menuSettings,
            :label => "Settings",
            :labelColor => Graphics.COLOR_LT_GRAY
        } );
    }

    public function onSelect() as Void {
        BaseViewMenuItem.onSelect();
        SettingsMenuHandler.showSettings( WatchUi.SLIDE_LEFT );
    }
}