import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Text` elements.
 * Currently, it relies entirely on the functionality provided 
 * by its base class and does not add any additional behavior.
 */
class SitemapText extends SitemapPrimitiveElement {
    public function initialize( data as JsonObject, isStateFresh as Boolean ) {
        SitemapPrimitiveElement.initialize( data, isStateFresh );
    }
}