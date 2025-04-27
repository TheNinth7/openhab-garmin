import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Timer;

class SiteMapRequest {
    private var _url as String;
    private var _sitemap as String;
    
    private var _menu as PageMenu?;
    //private var _timer as Timer.Timer = new Timer.Timer();

    public function getMenu() as PageMenu? {
        return _menu;
    }

    public function initialize() {
        _url = AppSettings.getUrl();
        _sitemap = AppSettings.getSitemap();
        makeRequest();
        //_timer.start( method( :makeRequest ), 1000, true );
    }

    private var _isStopped as Boolean = false;

    public function start() as Void {
        if( _isStopped ) {
            _isStopped = false;
            makeRequest();
        }
    }

    public function stop() as Void {
        _isStopped = true;
    }

    private function makeRequest() as Void {
        if( ! _isStopped ) {
            var url = _url + "/rest/sitemaps/" + _sitemap;

            var options = {
                :method => Communications.HTTP_REQUEST_METHOD_GET,
                :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
            };

            if( AppSettings.needsBasicAuth() ) {
                options[:headers] = { 
                    "Authorization" => "Basic " + StringUtil.encodeBase64( Lang.format( "$1$:$2$", [AppSettings.getUser(), AppSettings.getPassword() ] ) )
                };
            }

            Communications.makeWebRequest( url, null, options, method( :onReceive ) );
        }
    }


    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        try {
            if( responseCode != 200 ) {
                throw new CommunicationException( responseCode );
            }
            if( ! ( data instanceof Dictionary ) ) {
                throw new JsonParsingException( "Unexpected response: " + data );
            }
            var sitemapHomepage = new SitemapHomepage( data );
            if( _menu == null ) {
                _menu = new PageMenu( sitemapHomepage );
                WatchUi.switchToView( _menu, new PageMenuDelegate(), WatchUi.SLIDE_IMMEDIATE );
            } else {
                var menu = _menu as PageMenu;
                if( menu.update( sitemapHomepage ) == false ) {
                    WatchUi.switchToView( menu, new PageMenuDelegate(), WatchUi.SLIDE_BLINK );
                }
                WatchUi.requestUpdate();
            }

            makeRequest();
        } catch( ex ) {
            // handle the exception
            throw ex; // for now we just crash the app
        }
    }
}