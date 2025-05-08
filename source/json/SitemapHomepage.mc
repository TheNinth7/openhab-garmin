import Toybox.Lang;

/*
    This class represent the root element of the sitemap (Homepage)
*/
(:glance)
class SitemapHomepage extends SitemapPage {
    // The homepage uses different field names for label and id
    public var LABEL as String = "title";
    public var ID as String = "id";

    // Name of the homepage element
    private const HOMEPAGE = "homepage";

    public function initialize( data as JsonObject ) {
        // We extract the homepage element and pass 
        // it on to the super class
        SitemapPage.initialize( 
            getObject( data, HOMEPAGE, "Homepage: homepage element missing" )
        );
    }
}