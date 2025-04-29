import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Application.Storage;
import Toybox.Application;

class SitemapRequest extends BaseRequest {
    private static var _instance as SitemapRequest?;
    private static var _isStopped as Boolean = true;
    private static var _homePageMenu as PageMenu?;
    private static var _json as JsonObject?;

    private static const STORAGE_JSON as String = "json";

    private static function getInstance() as SitemapRequest {
        if( _instance == null ) {
            _instance = new SitemapRequest();
        }
        return _instance as SitemapRequest;
    }

    public static function initializeFromStorage() as PageMenu? {
        var json = Storage.getValue( STORAGE_JSON ) as JsonObject?;
        if( json != null ) {
            try {
                _homePageMenu = new PageMenu( new SitemapHomepage( json ) );
            } catch( ex ) {
                Logger.debugException( ex );
            }
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

    public static function persist() as Void {
        if( _json != null ) {
            Storage.setValue( STORAGE_JSON as String, _json as Dictionary<Application.PropertyKeyType, Application.PropertyValueType> );
        }
    }

    private var _url as String;

    private function initialize() {
        BaseRequest.initialize();
        _url = AppSettings.getUrl() + "/rest/sitemaps/" + AppSettings.getSitemap();
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON );
    }

    public function makeRequest() as Void {
        if( ! _isStopped ) {
            Communications.makeWebRequest( _url, null, getOptions(), method( :onReceive ) );
        }
    }

    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        // Logger.debug( "SitemapRequest.onReceive start" );
        try {
            if( ! _isStopped ) {
                checkResponseCode( responseCode );
                if( ! ( data instanceof Dictionary ) ) {
                    throw new JsonParsingException( "Unexpected response: " + data );
                }
                _json = data;
                var sitemapHomepage = new SitemapHomepage( data );
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