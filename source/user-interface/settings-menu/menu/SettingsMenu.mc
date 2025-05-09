import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
    The Settings Menu currently provides access to the 
    app version and server URL. In future more functionality
    may be added, such as switching between servers
*/
class SettingsMenu extends BaseMenu {

    public function initialize() {
        // Initialize the super class
        BaseMenu.initialize( {
            :title => "Settings",
            :itemHeight => Constants.UI_SETTINGS_ITEM_HEIGHT
        } );

        // Add entry for app version
        addItem( new SettingsTextMenuItem(
            "App Version",
            Application.loadResource( Rez.Strings.AppVersion ) as String
        ) );

        // Add entry for server URL
        addItem( new SettingsTextMenuItem(
            "Server",
            AppSettings.getUrl()
        ) );
    }
}