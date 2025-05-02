import Toybox.Lang;
import Toybox.PersistedContent;
import Toybox.Timer;

(:glance)
class GlanceSitemapRequest extends SitemapBaseRequest {
    private var _exception as Exception?;
    private const MINIMUM_POLLING_INTERVAL = 3000;

    public function consumeException() as Exception? {
        var ex = _exception;
        return ex;
    }
    
    public function initialize() {
        try {
            SitemapBaseRequest.initialize( MINIMUM_POLLING_INTERVAL );
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
        SitemapErrorCountStore.increment();
    }
}