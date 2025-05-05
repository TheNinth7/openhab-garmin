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
        Logger.debugException( ex );
        // Out of memory is ignored in the glance. If the glance does not have enough memory,
        // the response is simply not processed - basically the widget has to deal with 
        // sitemap loading on its own, without preloading from the Glance.
        if( ex instanceof CommunicationException && ex.getResponseCode() == -403 ) {
            stop();
        } else {
            _exception = ex;
            SitemapErrorCountStore.increment();
        }
    }
}