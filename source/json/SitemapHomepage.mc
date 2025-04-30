import Toybox.Lang;

(:glance)
class SitemapHomepage extends SitemapPage {
    private const HOMEPAGE = "homepage";
    public var LABEL as String = "title";
    public var ID as String = "id";

    public function initialize( data as JsonObject ) {
        SitemapPage.initialize( 
            getObject( data, HOMEPAGE, "Homepage: homepage element missing" )
        );
    }
}