import Toybox.Lang;
import Toybox.WatchUi;

class PageMenuItem extends BaseMenuItem {

    private var _menu as PageMenu;
    public function getMenu() as PageMenu {
        return _menu;
    }

    public function initialize( sitemapPage as SitemapPage ) {
        BaseMenuItem.initialize( sitemapPage, { :label => sitemapPage.label } );

        _menu = new PageMenu( sitemapPage );
    }

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return sitemapElement instanceof SitemapPage;
    }

    public function update( sitemapPage as SitemapPage ) as Boolean {
        setCustomLabel( sitemapPage.label );
        return _menu.update( sitemapPage );
    }
}