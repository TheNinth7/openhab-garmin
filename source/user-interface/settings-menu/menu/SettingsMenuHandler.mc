import Toybox.Lang;
import Toybox.WatchUi;

/*
    The settings menu handler is responsible for keeping track
    off the settings menu, and provides functions for showing
    and hiding it.
*/
class SettingsMenuHandler {
    // Both the menu itself and the delegate are kept here as
    // Singletons. The delegate implementation depends on
    // whether we are a button- or touch-based device.
    private static var _settingsMenu as SettingsMenu = new SettingsMenu();
    (:exclForTouch)
    private static var _settingsMenuDelegate as ButtonSettingsMenuDelegate = new ButtonSettingsMenuDelegate();
    (:exclForButton)
    private static var _settingsMenuDelegate as TouchSettingsMenuDelegate = new TouchSettingsMenuDelegate();

    // Are we currently showing the settings?
    private static var _isShowingSettings as Boolean = false;
    public static function isShowingSettings() as Boolean {
        return _isShowingSettings;
    }
    
    // Open the settings
    // The slide type not only defines the actual slide animation
    // but also which menu item shall be in focus in the settings menu
    // SLIDE_UP and SLIDE_DOWN are used on button devices,
    // SLIDE_RIGHT and SLIDE_LEFT for touch devices
    public static function showSettings( slide as SlideType ) as Void {
        if( _isShowingSettings ) {
            throw new GeneralException( "Called showSettings when settings were already shown" );
        }
        _isShowingSettings = true;

        // Ensure that we were called from the HomepageMenu
        if( ! ( WatchUi.getCurrentView()[0] instanceof HomepageMenu ) ) {
            throw new GeneralException( "showSettings can only be called from a HomepageMenu" );
        }

        // Depending on the slide type we decide which
        // settings menu item to focus
        if( slide == WatchUi.SLIDE_UP ) {
            _settingsMenu.focusFirst();
        } else if( slide == WatchUi.SLIDE_DOWN ){
            _settingsMenu.focusLast();
        } else if( slide == WatchUi.SLIDE_LEFT ){
            // do nothing, the menu will open either on the first
            // or if previously opened to whichever item was focused last
        } else {
            throw new GeneralException( "showSettings only supports SLIDE_UP, SLIDE_DOWN or SLIDE_LEFT" );
        }
        // Push the view on the view stack
        ViewHandler.pushView( _settingsMenu, _settingsMenuDelegate, slide );
    }
    
    // Hide the settings
    // Again, the slide type also decides on the focuse of the Homepage menu
    // we are returning to
    public static function hideSettings( slide as SlideType ) as Void {
        if( ! _isShowingSettings ) {
            throw new GeneralException( "Called hideSettings when settings were not shown" );
        }
        _isShowingSettings = false;

        // Depending on the slide type we decide which
        // homepage menu item to focus
        if( slide == WatchUi.SLIDE_UP ) {
            HomepageMenu.get().focusFirst();
        } else if( slide == WatchUi.SLIDE_DOWN ){
            HomepageMenu.get().focusLast();
        } else if( slide == WatchUi.SLIDE_RIGHT ){
            // do nothing, the menu will open either on the first
            // or if previously opened to whichever item was focused last
        } else {
            throw new GeneralException( "hideSettings only supports SLIDE_UP, SLIDE_DOWN or SLIDE_RIGHT" );
        }
        // Pop the view from the view stack
        ViewHandler.popView( slide );
    }
}