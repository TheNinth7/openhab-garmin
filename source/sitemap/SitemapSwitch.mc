import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Switch` elements.
 * Currently, it relies entirely on the functionality provided 
 * by its superclass and does not add any additional behavior.
 */
class SitemapSwitch extends SitemapPrimitiveElement {
    public function initialize( data as JsonObject ) {
        SitemapPrimitiveElement.initialize( data );
    }
}