import Toybox.Lang;
import Toybox.PersistedContent;
import Toybox.Timer;

(:glance)
class GlanceSitemapRequest extends SitemapBaseRequest {
    private var _exception as Exception?;
    private const TIMER_INTERVAL = 3000;

    public function checkForException() as Void {
        if( _exception != null ) {
            throw _exception;
        }
    }
    
    public function initialize() {
        try {
            SitemapBaseRequest.initialize( TIMER_INTERVAL );
            start();
        } catch( ex ) {
            _exception = ex;
        }
    }

    public function onSitemapUpdate( sitemapHomepage as SitemapHomepage ) as Void {
        Logger.debug( "GlanceSitemapRequest.onSitemapUpdate");
        _exception = null;
        WatchUi.requestUpdate();
    }

    public function onException( ex as Exception ) {
        Logger.debug( "GlanceSitemapRequest.onException");
        _exception = ex;
    }
}