import Toybox.Lang;

/*
 * Base class for asynchronous tasks that implement the
 * processing of menu initialization and update
 */
class BaseSitemapProcessorTask {
    protected function initialize() {
    }
    public function handleException( ex as Exception ) as Void {
        SitemapRequest.get().handleException( ex );
    }
}
