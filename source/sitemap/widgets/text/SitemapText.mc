import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Text` elements.
 * Currently, it relies entirely on the functionality provided 
 * by its base class and does not add any additional behavior.
 */
class SitemapText extends SitemapWidget {

    // The associated item and its state
    public var item as Item;

    public function initialize( 
        json as JsonAdapter, 
        initSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapWidget.initialize( json, initSitemapFresh, asyncProcessing );
        item = new Item( json.getObject( "item", "Text '" + label + "' has no item" ) );
    }
}