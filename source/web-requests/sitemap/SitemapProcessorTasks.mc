import Toybox.Lang;

/*
 * This file contains all classes that represent asynchronous tasks used for
 * processing incoming responses from SitemapRequest.
 *
 * For more details on how these tasks are used, see `SitemapProcessor`.
 */

// Base class that provides the exception handling
class BaseAsyncSitemapTask {
    protected var _sitemapProcessor as SitemapProcessor;
    protected function initialize( sitemapProcessor as SitemapProcessor ) {
        _sitemapProcessor = sitemapProcessor;
    }
    public function handleException( ex as Exception ) as Void {
        SitemapRequest.get().handleException( ex );
    }
}

// Create the sitemap
class CreateSitemapTask extends BaseAsyncSitemapTask {
    public function initialize( sitemapProcessor as SitemapProcessor ) {
        BaseAsyncSitemapTask.initialize( sitemapProcessor );
    }
    public function invoke() as Void {
        _sitemapProcessor.createSitemap();
    }
}

// Update the UI
class UpdateUiTask extends BaseAsyncSitemapTask {
    public function initialize( sitemapProcessor as SitemapProcessor ) {
        BaseAsyncSitemapTask.initialize( sitemapProcessor );
    }
    public function invoke() as Void {
        _sitemapProcessor.updateUi();
    }
}

// Trigger the next request
class TriggerNextRequestTask extends BaseAsyncSitemapTask {
    public function initialize( sitemapProcessor as SitemapProcessor ) {
        BaseAsyncSitemapTask.initialize( sitemapProcessor );
    }
    public function invoke() as Void {
        Logger.debug( "TriggerNextRequestTask.invoke" );
        SitemapRequest.get().triggerNextRequest();
    }
}
