import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
 * The `PageMenu` is used for frame elements that appear below the `Homepage` element.
 * Currently, it inherits all necessary functionality from `BasePageMenu` and does not
 * require any additional behavior.
 */
class PageMenu extends BasePageMenu {

    // See BasePageMenu.invalidateStructure for details
    private var _parent as BasePageMenu;
    public function invalidateStructure() as Void {
        _parent.invalidateStructure();
    }

    public function initialize( 
        sitemapPage as SitemapPage,
        parent as BasePageMenu 
    ) {
        BasePageMenu.initialize( sitemapPage, null );
        _parent = parent;
    }
}