import Toybox.Lang;
import Toybox.PersistedContent;
import Toybox.Timer;

class SitemapRequest extends SitemapBaseRequest {
    private static var _instance as SitemapRequest?;
    private static var _homePageMenu as PageMenu?;

    public static function getInstance() as SitemapRequest {
        if( _instance == null ) {
            _instance = new SitemapRequest();
        }
        return _instance as SitemapRequest;
    }

    public static function initializePageMenu() as PageMenu? {
        try {
            var sitemapHomepage = getInstance().getSitemapHomepage();
            if( sitemapHomepage != null ) {
                _homePageMenu = new PageMenu( sitemapHomepage );
            }
        } catch( ex ) {
            Logger.debugException( ex );
        }
        return _homePageMenu;
    }

    private function initialize() {
        SitemapBaseRequest.initialize( null );
    }

    public function onSitemapUpdate( sitemapHomepage as SitemapHomepage ) as Void {
        Logger.debug( "SitemapRequest.onSitemapUpdate");
        if( _homePageMenu == null ) {
            // There is no menu yet, so we need to switch
            // from the LoadingView to the menu
            _homePageMenu = new PageMenu( sitemapHomepage );
            WatchUi.switchToView( _homePageMenu, new PageMenuDelegate(), WatchUi.SLIDE_BLINK );
            ExceptionHandler.setUseToasts( true );
        } else {
            // To satisfy the typechecker, we get the member variable into a local variable
            var homepage = _homePageMenu as PageMenu;
            if( homepage.update( sitemapHomepage ) == false ) {
                Logger.debug( "SitemapRequest.onReceive: resetting to homepage" );
                // If update returns false, the menu structure has changed
                // and we therefore replace the current view stack with
                // the homepage
                ViewHandler.popToBottomAndSwitch( homepage, new PageMenuDelegate() );
            }
            WatchUi.requestUpdate();
        }
    }

    public function onSuccess() as Void {
        Logger.debug( "SitemapRequest.onSuccess");
        ExceptionHandler.resetCommunicationErrorCount();
    }

    public function onException( ex as Exception ) as Void {
        ExceptionHandler.handleException( ex );            
    }
}