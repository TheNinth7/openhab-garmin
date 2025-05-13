import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item implementation represents a page—i.e., a container 
 * that holds other menu items. It is currently used for sitemap Frame elements.
 * The item's label displays the Frame's label, and in onSelectImpl(), 
 * it opens a PageMenu representing the Frame's content.
 */
class PageMenuItem extends BaseSitemapMenuItem {

    private var _menu as PageMenu;

    // Constructor  
    // Initializes the base class and sets the menu view to open when this item is selected.
    public function initialize( sitemapPage as SitemapPage ) {
        BaseSitemapMenuItem.initialize( { 
            :id => sitemapPage.id,
            :label => sitemapPage.label 
        } );

        _menu = new PageMenu( sitemapPage );
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return sitemapElement instanceof SitemapPage;
    }

    // Updates the page menu item by refreshing its label 
    // and invoking the update() method on its submenu.
    public function update( sitemapElement as SitemapElement ) as Boolean {
        var sitemapPage = sitemapElement as SitemapPage;
        setLabel( sitemapPage.label );
        return _menu.update( sitemapPage );
    }

    // If selected, the associated menu will be pushed on the stack
    public function onSelect() as Void {
        ViewHandler.pushView( _menu, PageMenuDelegate.get(), WatchUi.SLIDE_LEFT );
    }
}