import Toybox.Lang;

/*
 * Task for asynchronously creating a sitemap element and
 * adding it to the parent container.
 */
class SitemapContainerBuildTask extends BaseSitemapProcessorTask {
    private var _sitemapPage as SitemapPage;
    private var _widget as JsonAdapter;
    private var _type as String;

    // Constructor
    // Storing all the data we need for adding
    public function initialize( 
        sitemapPage as SitemapPage, 
        widget as JsonAdapter
    ) {
        BaseSitemapProcessorTask.initialize();
        _sitemapPage = sitemapPage;
        _widget = widget;
    }
    
    // Add the element
    public function invoke() as Void {
        _sitemapPage.widgets.add(
            SitemapWidgetFactory.createByType( 
                _widget,
                _sitemapPage.isSitemapFresh,
                true
            )
        );
    }
}