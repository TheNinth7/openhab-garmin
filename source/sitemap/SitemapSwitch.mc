import Toybox.Lang;
import Toybox.WatchUi;

/*
    Class representing Switch elements
    Currently does not need anything in addition to
    what the super class implements
*/
class SitemapSwitch extends SitemapPrimitiveElement {
    public function initialize( data as JsonObject ) {
        SitemapPrimitiveElement.initialize( data );
    }
}