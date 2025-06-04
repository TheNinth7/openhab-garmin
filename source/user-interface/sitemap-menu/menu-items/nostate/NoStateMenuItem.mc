import Toybox.Lang;
import Toybox.WatchUi;

class NoStateMenuItem extends BaseWidgetMenuItem {
    
    // Constructor
    public function initialize( sitemapWidget as SitemapWidget, parent as BasePageMenu ) {
        BaseWidgetMenuItem.initialize( {
                :sitemapWidget => sitemapWidget,
                :state => new StatusText( "—" ),
                :parent => parent
            }
        );
    }

    // Updates the menu item
    // No action needed here - once a state becomes available, this
    // item will be replaced by the actual menu item for this element
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        BaseWidgetMenuItem.updateWidget( sitemapWidget );
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
