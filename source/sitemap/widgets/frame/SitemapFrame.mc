import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Frame` elements.
 *
 * For frames, the list of widgets is embedded at the same JSON level as the widget itself.
 * Therefore, we populate the `linkedPage` member of the parent class with a
 * `SitemapFramePage`, created from the JSON object passed into this widget.
 */
class SitemapFrame extends SitemapWidget {

    public var linkedFrame as SitemapFramePage;

    public function initialize( 
        json as JsonAdapter, 
        isSitemapFresh as Boolean, 
        asyncProcessing as Boolean 
    ) {
        SitemapWidget.initialize( json, isSitemapFresh, asyncProcessing );
        linkedFrame = new SitemapFramePage( json, isSitemapFresh, asyncProcessing );
        linkedPage = linkedFrame;
    }
}