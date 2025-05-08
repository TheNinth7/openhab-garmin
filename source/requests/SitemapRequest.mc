import Toybox.Lang;
import Toybox.PersistedContent;
import Toybox.Timer;

class SitemapRequest extends SitemapBaseRequest {
    private static var _instance as SitemapRequest?;
    private static var _homepageMenu as HomepageMenu?;

    public static function getInstance() as SitemapRequest {
        if( _instance == null ) {
            _instance = new SitemapRequest();
        }
        return _instance as SitemapRequest;
    }

    public static function initializeMenu() as HomepageMenu? {
        try {
            var sitemapHomepage = getInstance().getSitemapHomepage();
            if( sitemapHomepage != null ) {
                _homepageMenu = new HomepageMenu( sitemapHomepage );
            }
        } catch( ex ) {
            Logger.debugException( ex );
        }
        return _homepageMenu;
    }

    private function initialize() {
        SitemapBaseRequest.initialize( null );
    }

    public function onSitemapUpdate( sitemapHomepage as SitemapHomepage ) as Void {
        Logger.debug( "SitemapRequest.onSitemapUpdate");
        if( _homepageMenu == null ) {
            // There is no menu yet, so we need to switch
            // from the LoadingView to the menu
            _homepageMenu = new HomepageMenu( sitemapHomepage );
            WatchUi.switchToView( _homepageMenu, HomepageMenuDelegate.get(), WatchUi.SLIDE_BLINK );
        } else {
            // To satisfy the typechecker, we get the member variable into a local variable
            var homepage = _homepageMenu as PageMenu;
            var remainsValid = homepage.update( sitemapHomepage );
            if( ! SettingsMenuHandler.isShowingSettings() ) {
                if( ! remainsValid && ! ErrorViewHandler.isShowingErrorView() ) {
                    Logger.debug( "SitemapRequest.onReceive: resetting to homepage" );
                    // If update returns false, the menu structure has changed
                    // and we therefore replace the current view stack with
                    // the homepage
                    ViewHandler.popToBottomAndSwitch( homepage, HomepageMenuDelegate.get() );
                } else if( ErrorViewHandler.isShowingErrorView() ) {
                    ErrorViewHandler.replaceErrorView( homepage, HomepageMenuDelegate.get() );
                }
                WatchUi.requestUpdate();
            }
        }
    }

    public function onException( ex as Exception ) as Void {
        ExceptionHandler.handleException( ex );            
    }
}