import Toybox.Lang;
import Toybox.WatchUi;

/*
    Class representing Text elements
    Currently does not need anything in addition to
    what the super class implements
*/
class SitemapText extends SitemapPrimitiveElement {
    public function initialize( data as JsonObject ) {
        SitemapPrimitiveElement.initialize( data );
    }
}