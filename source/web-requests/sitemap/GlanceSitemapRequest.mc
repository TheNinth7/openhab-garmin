import Toybox.Lang;
import Toybox.PersistedContent;
import Toybox.Timer;

/*
    Sitemap request used by the glance.
    While it also provides updates of the homepage label displayed,
    the main purpose of requesting the sitemap in the glance is
    to have up to date data in storage when the widget starts
*/
(:glance)
class GlanceSitemapRequest extends BaseSitemapRequest {

    // Although currently the glance does not display
    // communication exceptions, this class stores
    // and makes them available
    private var _exception as Exception?;
    public function consumeException() as Exception? {
        var ex = _exception;
        return ex;
    }
    
    // Even if the polling interval in the setting is lower,
    // this is the minimum polling interval applied for the
    // glance
    private const GLANCE_MINIMUM_POLLING_INTERVAL = 3000;

    // Constructor
    // For the glance, the constructor starts the sitemap request
    // immediately    
    public function initialize() {
        try {
            BaseSitemapRequest.initialize( GLANCE_MINIMUM_POLLING_INTERVAL );
            start();
        } catch( ex ) {
            _exception = ex;
        }
    }

    // Update the screen whenever an update to the sitemap has been received
    public function onSitemapUpdate( sitemapHomepage as SitemapHomepage ) as Void {
        // Logger.debug( "GlanceSitemapRequest.onSitemapUpdate");
        _exception = null;
        WatchUi.requestUpdate();
    }

    // Exceptions are stored, but more importantly, the error
    // count is incremented, so that if there is a persisting
    // error, the widget starts right away with an error view
    public function onException( ex as Exception ) {
        // Logger.debug( "GlanceSitemapRequest.onException");
        Logger.debugException( ex );
        // Out of memory is ignored in the glance. If the glance does not have enough memory,
        // the response is simply not processed - basically the widget has to deal with 
        // sitemap loading on its own, without preloading from the Glance.
        if( ex instanceof CommunicationException && ex.getResponseCode() == -403 ) {
            stop();
        } else {
            _exception = ex;
        }
    }
}