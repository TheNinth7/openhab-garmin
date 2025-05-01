import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Application.Storage;
import Toybox.Application;
import Toybox.Timer;

(:glance)
class SitemapBaseRequest extends BaseRequest {
    private static const STORAGE_JSON as String = "json";

    private var _url as String;
    private var _json as JsonObject?;

    private var _sitemapHomepage as SitemapHomepage?;

    private var _isStopped as Boolean = true;
    private var _pollingInterval as Number;
    private var _timer as Timer.Timer = new Timer.Timer();

    public function getSitemapHomepage() as SitemapHomepage? {
        return _sitemapHomepage;
    }

    protected function onSitemapUpdate( sitemapHomepage as SitemapHomepage ) as Void {
        throw new AbstractMethodException( "BaseSitemapRequest.onSitemapUpdate" );
    }
    protected function onException( ex as Exception ) as Void {
        throw new AbstractMethodException( "BaseSitemapRequest.onException" );
    }

    protected function onSuccess() as Void;

    protected function initialize( minimumPollingInterval as Number? ) {
        BaseRequest.initialize();

        _pollingInterval = AppSettings.getPollingInterval();
        if( minimumPollingInterval != null && _pollingInterval < minimumPollingInterval ) {
            _pollingInterval = minimumPollingInterval;
        }

        _json = Storage.getValue( STORAGE_JSON ) as JsonObject?;
        if( _json != null ) {
            _sitemapHomepage = new SitemapHomepage( _json );
        }
        _url = AppSettings.getUrl() + "/rest/sitemaps/" + AppSettings.getSitemap();
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON );
    }

    public function start() as Void {
        if( _isStopped ) {
            _isStopped = false;
            makeRequest();
        }
    }

    public function stop() as Void {
        _isStopped = true;
    }

    public function makeRequest() as Void {
        Logger.debug( "BaseSitemapRequest.makeRequest");
        if( ! _isStopped ) {
            Communications.makeWebRequest( _url, null, getOptions(), method( :onReceive ) );
        }
    }

    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        Logger.debug( "BaseSitemapRequest.onReceive");
        if( ! _isStopped ) {
            try {
                checkResponseCode( responseCode, CommunicationException.EX_SOURCE_SITEMAP );
                if( ! ( data instanceof Dictionary ) ) {
                    throw new JsonParsingException( "Unexpected response: " + data );
                }
                _json = data;
                _sitemapHomepage = new SitemapHomepage( data );
                onSitemapUpdate( _sitemapHomepage );
            } catch( ex ) {
                onException( ex );
            }

            if( _pollingInterval > 0 ) {
                Logger.debug( "BaseSitemapRequest: starting timer for " + _pollingInterval + "ms" );
                _timer.start( method( :makeRequest ), _pollingInterval, false );
            } else {
                makeRequest();
            }
            
            onSuccess();
        }
    }

    public function persist() as Void {
        if( _json != null ) {
            Storage.setValue( STORAGE_JSON as String, _json as Dictionary<Application.PropertyKeyType, Application.PropertyValueType> );
        }
    }
}