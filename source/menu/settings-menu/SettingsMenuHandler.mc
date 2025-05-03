import Toybox.Lang;
import Toybox.WatchUi;

class SettingsMenuHandler {
    private static var _settingsMenu as SettingsMenu = new SettingsMenu();
    private static var _settingsMenuDelegate as SettingsMenuDelegate = new SettingsMenuDelegate();
    private static var _showsSettings as Boolean = false;
    private static var _viewBeforeSettings as HomepageMenu?;

    public static function showsSettings() as Boolean {
        return _showsSettings;
    }
    public static function showSettings( slide as SlideType ) as Void {
        if( _showsSettings ) {
            throw new GeneralException( "Called showSettings when settings were already shown" );
        }
        var currentView = WatchUi.getCurrentView()[0];
        if( ! ( currentView instanceof HomepageMenu ) ) {
            throw new GeneralException( "showSettings can only be called from a HomepageMenu" );
        }
        _viewBeforeSettings = currentView as HomepageMenu;
        _showsSettings = true;
        if( slide == WatchUi.SLIDE_UP ) {
            _settingsMenu.focusFirst();
        } else if( slide == WatchUi.SLIDE_DOWN ){
            _settingsMenu.focusLast();
        } else {
            throw new GeneralException( "showSettings only supports SLIDE_UP or SLIDE_DOWN" );
        }
        ViewHandler.pushView( _settingsMenu, _settingsMenuDelegate, slide );
    }
    public static function hideSettings( slide as SlideType ) as Void {
        if( ! _showsSettings || _viewBeforeSettings == null ) {
            throw new GeneralException( "Called hideSettings when settings were not shown" );
        }
        var viewBeforeSettings = _viewBeforeSettings as HomepageMenu;
        _showsSettings = false;
        ViewHandler.popView( slide );
        if( slide == WatchUi.SLIDE_UP ) {
            viewBeforeSettings.focusFirst();
        } else if( slide == WatchUi.SLIDE_DOWN ){
            viewBeforeSettings.focusLast();
        } else {
            throw new GeneralException( "hideSettings only supports SLIDE_UP or SLIDE_DOWN" );
        }
    }
}