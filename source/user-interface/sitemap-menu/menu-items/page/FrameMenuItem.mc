import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item implementation represents a frame, a container 
 * that holds other menu items.
 * The item's label displays the Frame's label, and in onSelectImpl(), 
 * it opens a PageMenu representing the Frame's content.
 */
class FrameMenuItem extends BaseSitemapMenuItem {

    private var _menu as PageMenu;

    // Constructor  
    // Initializes the base class and sets the menu view to open when this item is selected.
    public function initialize( sitemapFrame as SitemapFrame, parent as BasePageMenu ) {
        BaseSitemapMenuItem.initialize( { 
            :sitemapWidget => sitemapFrame
        } );

        _menu = new PageMenu( sitemapFrame.linkedFrame, parent );
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return sitemapWidget instanceof SitemapFrame;
    }

    // Updates the page menu item by refreshing its label 
    // and invoking the update() method on its submenu.
    public function update( sitemapWidget as SitemapWidget ) as Void {
        BaseSitemapMenuItem.update( sitemapWidget );
        if( ! ( sitemapWidget instanceof SitemapFrame ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapWidget.label + "' was passed into FrameMenuItem but is of a different type" );
        }

        _menu.update( sitemapWidget.linkedFrame );
    }

    // If selected, the associated menu will be pushed on the stack
    public function onSelect() as Void {
        ViewHandler.pushView( _menu, PageMenuDelegate.get(), WatchUi.SLIDE_LEFT );
    }
}