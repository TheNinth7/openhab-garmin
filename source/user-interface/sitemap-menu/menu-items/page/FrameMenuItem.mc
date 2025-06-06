import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item implementation represents a frame, a container 
 * that holds other menu items.
 * The item's label displays the Frame's label, and in onSelectImpl(), 
 * it opens a PageMenu representing the Frame's content.
 */
class FrameMenuItem extends BaseWidgetMenuItem {

    // Constructor  
    // Initializes the base class and sets the menu view to open when this item is selected.
    public function initialize( 
        sitemapFrame as SitemapFrame, 
        parent as BasePageMenu 
    ) {
        BaseWidgetMenuItem.initialize( { 
            :sitemapWidget => sitemapFrame,
            :parent => parent 
        } );
    }

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return sitemapWidget instanceof SitemapFrame;
    }
}