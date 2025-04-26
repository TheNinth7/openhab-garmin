import Toybox.Lang;

class SitemapHomepage extends SitemapPage {
    private const HOMEPAGE = "homepage";
    public var LABEL as String = "title";

    function initialize( data as JsonObject ) {
        SitemapPage.initialize( 
            getObject( data, HOMEPAGE, "Homepage: homepage element missing!" )
        );
    }
}