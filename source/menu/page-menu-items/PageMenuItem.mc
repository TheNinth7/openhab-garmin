import Toybox.Lang;
import Toybox.WatchUi;

class PageMenuItem extends BaseMenuItem {

    private var _menu as PageMenu;

    public function initialize( sitemapPage as SitemapPage ) {
        BaseMenuItem.initialize( sitemapPage, { :label => sitemapPage.label } );

        _menu = new PageMenu( sitemapPage );
    }

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return sitemapElement instanceof SitemapPage;
    }

    public function update( sitemapElement as SitemapElement ) as Boolean {
        var sitemapPage = sitemapElement as SitemapPage;
        setCustomLabel( sitemapPage.label );
        return _menu.update( sitemapPage );
    }

    public function onSelect() as Void {
        ViewHandler.pushView( _menu, new PageMenuDelegate(), WatchUi.SLIDE_LEFT );
    }
}