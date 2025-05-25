import Toybox.Lang;

/*
 * Task for asynchronously creating a sitemap element and
 * adding it to the parent sitemap page.
 */
class SitemapPageBuildTask {
    private var _sitemapPage as SitemapPage;
    private var _widget as JsonObject;
    private var _type as String;

    // Constructor
    // Storing all the data we need for adding
    public function initialize( 
        sitemapPage as SitemapPage, 
        widget as JsonObject,
        type as String
    ) {
        _sitemapPage = sitemapPage;
        _widget = widget;
        _type = type;
    }
    
    // Add the element
    public function invoke() as Void {
        _sitemapPage.elements.add(
            SitemapElementFactory.createByType( 
                _type, 
                _widget,
                _sitemapPage.isSitemapFresh,
                true
            )
        );
    }

    // Handle any exceptions 
    public function handleException( ex as Exception ) as Void {
        SitemapRequest.get().handleException( ex );
    }
}