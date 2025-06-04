import Toybox.Lang;

/*
 * This class represents the root element of the sitemap (Homepage).
 */
class SitemapHomepage extends SitemapPage {

    public function initialize( 
        json as JsonAdapter, 
        initSitemapFresh as Boolean,
        asyncProcessing as Boolean 
    ) {
        // We extract the homepage element and pass 
        // it on to the super class
        SitemapPage.initialize( 
            json.getObject( "homepage", "Homepage: homepage element missing" ),
            initSitemapFresh,
            asyncProcessing
        );
    }
}