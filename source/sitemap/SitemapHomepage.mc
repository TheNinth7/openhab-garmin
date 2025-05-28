import Toybox.Lang;

/*
 * This class represents the root element of the sitemap (Homepage).
 */
class SitemapHomepage extends SitemapPage {
    // The homepage uses different field names for label and id
    public var LABEL as String = "title";
    public var ID as String = "id";

    // Name of the homepage element
    private const HOMEPAGE = "homepage";

    public function initialize( 
        data as JsonObject, 
        isSitemapFresh as Boolean,
        asyncProcessing as Boolean 
    ) {
        //var start = System.getTimer();
        // We extract the homepage element and pass 
        // it on to the super class
        SitemapPage.initialize( 
            getObject( data, HOMEPAGE, "Homepage: homepage element missing" ),
            isSitemapFresh,
            asyncProcessing
        );
        //var end = System.getTimer();
        //// Logger.debug( "SitemapHomepage.initialize: " + ( end - start ) + "ms" );
    }
}