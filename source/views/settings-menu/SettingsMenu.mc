import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class SettingsMenu extends BaseMenu {

    public function initialize() {
        BaseMenu.initialize( {
            :title => "Settings",
            :itemHeight => Constants.UI_SETTINGS_ITEM_HEIGHT
        } );

        addItem( new SettingsTextMenuItem(
            "App Version",
            Application.loadResource( Rez.Strings.AppVersion ) as String
        ) );

        addItem( new SettingsTextMenuItem(
            "Server",
            AppSettings.getUrl()
        ) );
    }
}