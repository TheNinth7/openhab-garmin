import Toybox.Lang;
import Toybox.PersistedContent;
import Toybox.Timer;

(:glance)
class GlanceSitemapRequest extends SitemapBaseRequest {
    private var _exception as Exception?;
    private var _timer as Timer.Timer = new Timer.Timer();
    private const TIMER_INTERVAL = 1000;

    public function checkForException() as Void {
        if( _exception != null ) {
            throw _exception;
        }
    }
    
    public function initialize() {
        try {
            SitemapBaseRequest.initialize();
            makeRequest();
        } catch( ex ) {
            _exception = ex;
        }
    }

    public function makeRequest() as Void {
        SitemapBaseRequest.baseMakeRequest( method( :onReceive ) );
    }

    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        _exception = null;
        try {
            baseOnReceive( responseCode, data );
            WatchUi.requestUpdate();
            _timer.start( method( :makeRequest), TIMER_INTERVAL, false );
        } catch( ex ) {
            _exception = ex;
        }
    }
}