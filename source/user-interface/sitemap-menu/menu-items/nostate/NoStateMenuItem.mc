import Toybox.Lang;
import Toybox.WatchUi;

class NoStateMenuItem extends BaseSitemapMenuItem {
    
    // Constructor
    public function initialize( sitemapWidget as SitemapWidget ) {
        BaseSitemapMenuItem.initialize(
            {
                :sitemapWidget => sitemapWidget,
                :state => new StatusText( "—" )
            }
        );
    }

    // Updates the menu item
    // No action needed here - once a state becomes available, this
    // item will be replaced by the actual menu item for this element
    public function update( sitemapWidget as SitemapWidget ) as Void {
        BaseSitemapMenuItem.update( sitemapWidget );
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {

        if( ! sitemapWidget.hasTransformedState() ) {
            if( sitemapWidget has :item ) {
                var item = sitemapWidget.item;
                if( item != null ) {
                    return ! ( sitemapWidget.item as Item ).hasState();
                }
            }
        }
        return false;
    }
}
