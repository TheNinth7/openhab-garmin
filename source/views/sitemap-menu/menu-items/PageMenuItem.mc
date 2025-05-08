import Toybox.Lang;
import Toybox.WatchUi;

class PageMenuItem extends BaseViewMenuItem {

    private var _menu as PageMenu;

    public function initialize( sitemapPage as SitemapPage, parentMenu as CustomMenu ) {
        BaseViewMenuItem.initialize( { 
            :id => sitemapPage.id,
            :parentMenu => parentMenu,
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

    public function onSelectImpl() as Void {
        ViewHandler.pushView( _menu, PageMenuDelegate.get(), WatchUi.SLIDE_LEFT );
    }
}