import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Represents a sitemap page, either the homepage (see the `SitemapHomepage` subclass)
 * or a subpage defined by a widget.
 *
 * This class builds on the `SitemapContainer` base class, which handles parsing of
 * the widgets contained in the page.
 *
 * It shares this base class with `SitemapFramePage`. The only difference between a
 * frame and a regular page is the field name used for the title, which is why the
 * title is handled in the subclasses rather than in the base class.
 */
class SitemapPage extends SitemapContainer {

    // Title of the page
    public var title as String;

    // Constructor
    public function initialize( 
        json as JsonAdapter, 
        initSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapContainer.initialize( json, initSitemapFresh, asyncProcessing );
        title = parseLabelState( json, "title", "Page title is missing" )[0];
    }
}