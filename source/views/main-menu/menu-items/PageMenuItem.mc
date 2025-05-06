import Toybox.Lang;
import Toybox.WatchUi;

class PageMenuItem extends BaseSitemapMenuItem {

    private var _menu as PageMenu;

    public function initialize( sitemapPage as SitemapPage ) {
        BaseSitemapMenuItem.initialize( { 
            :id => sitemapPage.id,
            :label => sitemapPage.label 
        } );

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