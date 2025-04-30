import Toybox.Lang;
import Toybox.PersistedContent;

class SitemapRequest extends SitemapBaseRequest {
    private static var _instance as SitemapRequest?;
    private static var _isStopped as Boolean = true;
    private static var _homePageMenu as PageMenu?;

    private static function getInstance() as SitemapRequest {
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

    public static function start() as Void {
        var instance = getInstance();
        if( _isStopped ) {
            _isStopped = false;
            instance.makeRequest();
        }
    }

    public static function stop() as Void {
        _isStopped = true;
    }

    public static function staticPersist() as Void {
        getInstance().persist();
    }

    private function initialize() {
        SitemapBaseRequest.initialize();
    }

    public function makeRequest() as Void {
        if( ! _isStopped ) {
            SitemapBaseRequest.baseMakeRequest( method( :onReceive ) );
        }
    }

    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        // Logger.debug( "SitemapRequest.onReceive start" );
        try {
            if( ! _isStopped ) {
                var sitemapHomepage = baseOnReceive( responseCode, data );
                if( _homePageMenu == null ) {
                    // There is no menu yet, so we need to switch
                    // from the LoadingView to the menu
                    _homePageMenu = new PageMenu( sitemapHomepage );
                    WatchUi.switchToView( _homePageMenu, new PageMenuDelegate(), WatchUi.SLIDE_BLINK );
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
                ExceptionHandler.setHasCurrentSitemap( true );
                makeRequest();
            }
        } catch( ex ) {
            ExceptionHandler.handleException( ex );            
        }
        // Logger.debug( "SitemapRequest.onReceive end" );
    }
}