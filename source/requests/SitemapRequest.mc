import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Timer;

class SiteMapRequest {
    private var _url as String;
    private var _sitemap as String;
    
    private var _menu as PageMenu?;
    private var _timer as Timer.Timer = new Timer.Timer();

    public function getMenu() as PageMenu? {
        return _menu;
    }

    public function initialize( index as Number ) {
        _url = "http://net-nas-1:8080";
        _sitemap = "garmin_hierarchical";
        makeRequest();
        _timer.start( method( :makeRequest ), 1000, true );
    }

    public function stop() as Void {
        _timer.stop();
        Communications.cancelAllRequests();
    }

    public function makeRequest() as Void {
        var url = _url + "/rest/sitemaps/" + _sitemap;

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        /*
        if( siteConfig.needsBasicAuth() ) {
            options[:headers] = { 
                "Authorization" => "Basic " + StringUtil.encodeBase64( Lang.format( "$1$:$2$", [siteConfig.getUser(), siteConfig.getPassword() ] ) )
            };
        }
        */
        Communications.makeWebRequest( url, null, options, method( :onReceive ) );
    }


    function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
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
        } catch( ex ) {
            // handle the exception
            throw ex; // for now we just crash the app
        }
    }
}