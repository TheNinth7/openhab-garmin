import Toybox.Lang;
import Toybox.WatchUi;

class PageMenuItem extends MenuItem {

    private var _menu as PageMenu;
    public function getMenu() as PageMenu {
        return _menu;
    }

    function initialize( sitemapPage as SitemapPage ) {
        MenuItem.initialize(
            sitemapPage.label,
            null,
            sitemapPage.id, // identifier
            null
        );

        _menu = new PageMenu( sitemapPage );
    }

    function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return sitemapElement instanceof SitemapPage;
    }

    function update( sitemapPage as SitemapPage ) as Boolean {
        setLabel( sitemapPage.label );
        return _menu.update( sitemapPage );
    }
}