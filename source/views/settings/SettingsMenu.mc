import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class SettingsMenu extends BaseMenu {

    public static var ITEM_HEIGHT as Number = 
        ( System.getDeviceSettings().screenHeight * 0.3 ).toNumber();

    public function initialize() {
        BaseMenu.initialize( {
            :title => "Settings",
            :itemHeight => ITEM_HEIGHT
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