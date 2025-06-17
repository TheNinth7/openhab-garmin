import Toybox.Lang;

/*
 * Task for asynchronously creating a sitemap element and
 * adding it to the parent container.
 */
class SitemapContainerBuildTask extends BaseSitemapProcessorTask {
    private var _sitemapContainer as SitemapContainer;
    private var _widget as JsonAdapter;
    private var _taskQueue as TaskQueue;

    // Constructor
    // Storing all the data we need for adding
    public function initialize( 
        sitemapContainer as SitemapContainer, 
        widget as JsonAdapter,
        taskQueue as TaskQueue
    ) {
        BaseSitemapProcessorTask.initialize();
        _sitemapContainer = sitemapContainer;
        _widget = widget;
        _taskQueue = taskQueue;
    }
    
    // Add the element
    public function invoke() as Void {
        _sitemapContainer.addWidget(
            SitemapWidgetFactory.createByType( 
                _widget,
                _sitemapContainer.isSitemapFresh(),
                _taskQueue
            )
        );
    }
}