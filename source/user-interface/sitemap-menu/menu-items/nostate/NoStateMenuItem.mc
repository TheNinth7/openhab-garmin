import Toybox.Lang;
import Toybox.WatchUi;

class NoStateMenuItem extends BaseSitemapMenuItem {
    
    // Constructor
    public function initialize( sitemapPrimitiveElement as SitemapPrimitiveElement ) {
        BaseSitemapMenuItem.initialize(
            {
                :SitemapElement => sitemapPrimitiveElement,
                :state => new StatusText( "—" )
            }
        );
    }

    // Updates the menu item
    // No action needed here - once a state becomes available, this
    // item will be replaced by the actual menu item for this element
    public function update( sitemapWidget as SitemapWidget ) as Void {
        BaseSitemapMenuItem.update( sitemapElement );
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return 
            sitemapElement instanceof SitemapPrimitiveElement
            && ! sitemapElement.item.hasState() 
            && ! sitemapElement.hasWidgetState();
    }
}
