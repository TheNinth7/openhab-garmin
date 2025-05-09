import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
 * The `PageMenu` is used for frame elements that appear below the `Homepage` element.
 * Currently, it inherits all necessary functionality from `BasePageMenu` and does not
 * require any additional behavior.
 */
class PageMenu extends BasePageMenu {
    public function initialize( sitemapPage as SitemapPage ) {
        BasePageMenu.initialize( sitemapPage, null );
    }
}