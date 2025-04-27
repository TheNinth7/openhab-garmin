import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;

class SitemapRequest extends BaseRequest {
    private static var _instance as SitemapRequest?;
    
    private static function getInstance() as SitemapRequest {
        if( _instance == null ) {
            _instance = new SitemapRequest();
        }
        return _instance as SitemapRequest;
    }

    private var _url as String;

    public var menu as PageMenu?;

    public static function getMenu() as PageMenu? {
        return getInstance().menu;
    }

    private function initialize() {
        BaseRequest.initialize();
        _url = AppSettings.getUrl() + "/rest/sitemaps/" + AppSettings.getSitemap();
        _options[:responseType] = Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON;
    }

    public var isStopped as Boolean = true;

    public static function start() as Void {
        var instance = getInstance();
        if( instance.isStopped ) {
            instance.isStopped = false;
            instance.makeRequest();
        }
    }

    public static function stop() as Void {
        getInstance().isStopped = true;
    }

    public function makeRequest() as Void {
        if( ! isStopped ) {
            Communications.makeWebRequest( _url, null, _options, method( :onReceive ) );
        }
    }

    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        try {
            if( ! isStopped ) {
                checkResponseCode( responseCode );
                if( ! ( data instanceof Dictionary ) ) {
                    throw new JsonParsingException( "Unexpected response: " + data );
                }
                var sitemapHomepage = new SitemapHomepage( data );
                if( menu == null ) {
                    menu = new PageMenu( sitemapHomepage );
                    WatchUi.switchToView( menu, new PageMenuDelegate(), WatchUi.SLIDE_IMMEDIATE );
                } else {
                    var lmenu = menu as PageMenu;
                    if( lmenu.update( sitemapHomepage ) == false ) {
                        WatchUi.switchToView( lmenu, new PageMenuDelegate(), WatchUi.SLIDE_BLINK );
                    }
                    WatchUi.requestUpdate();
                }

                makeRequest();
            }
        } catch( ex ) {
            ExceptionHandler.handleException( ex );            
        }
    }
}