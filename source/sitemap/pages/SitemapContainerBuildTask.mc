import Toybox.Lang;

/*
 * Task for asynchronously creating a sitemap element and
 * adding it to the parent container.
 */
class SitemapContainerBuildTask extends BaseSitemapProcessorTask {
    private var _sitemapContainer as SitemapContainer;
    private var _widget as JsonAdapter;

    // Constructor
    // Storing all the data we need for adding
    public function initialize( 
        sitemapContainer as SitemapContainer, 
        widget as JsonAdapter
    ) {
        BaseSitemapProcessorTask.initialize();
        _sitemapContainer = sitemapContainer;
        _widget = widget;
    }
    
    // Add the element
    public function invoke() as Void {
        _sitemapContainer.widgets.add(
            SitemapWidgetFactory.createByType( 
                _widget,
                _sitemapContainer.isSitemapFresh,
                true
            )
        );
    }
}