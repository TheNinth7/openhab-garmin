import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Application.Storage;
import Toybox.Application;

(:glance)
class SitemapBaseRequest extends BaseRequest {
    private static const STORAGE_JSON as String = "json";

    private var _url as String;
    private var _json as JsonObject?;

    private var _sitemapHomepage as SitemapHomepage?;

    public function getSitemapHomepage() as SitemapHomepage? {
        return _sitemapHomepage;
    }

    public function persist() as Void {
        if( _json != null ) {
            Storage.setValue( STORAGE_JSON as String, _json as Dictionary<Application.PropertyKeyType, Application.PropertyValueType> );
        }
    }

    protected function initialize() {
        BaseRequest.initialize();
        _json = Storage.getValue( STORAGE_JSON ) as JsonObject?;
        if( _json != null ) {
            _sitemapHomepage = new SitemapHomepage( _json );
        }
        _url = AppSettings.getUrl() + "/rest/sitemaps/" + AppSettings.getSitemap();
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON );
    }

    protected function baseMakeRequest( responseCallback as Method(responseCode as Lang.Number, data as Lang.Dictionary or Lang.String or PersistedContent.Iterator or Null) as Void ) as Void {
        Communications.makeWebRequest( _url, null, getOptions(), responseCallback );
    }

    protected function baseOnReceive(  responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as SitemapHomepage {
        checkResponseCode( responseCode, CommunicationException.EX_SOURCE_SITEMAP );
        if( ! ( data instanceof Dictionary ) ) {
            throw new JsonParsingException( "Unexpected response: " + data );
        }
        _json = data;
        _sitemapHomepage = new SitemapHomepage( data );
        return _sitemapHomepage;
    }
}