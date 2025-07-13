/*
import Toybox.Lang;
import Toybox.WatchUi;

class NoStateMenuItem extends BaseWidgetMenuItem {
    
    // Constructor
    public function initialize( 
        sitemapWidget as SitemapWidget, 
        parent as BasePageMenu,
        processingMode as BasePageMenu.ProcessingMode 
    ) {
        BaseWidgetMenuItem.initialize( {
                :sitemapWidget => sitemapWidget,
                :stateDrawable => new StateText( "—" ),
                :parent => parent,
                :processingMode => processingMode
            }
        );
    }

    // Updates the menu item
    // No action needed here - once a state becomes available, this
    // item will be replaced by the actual menu item for this element
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        BaseWidgetMenuItem.updateWidget( sitemapWidget );
    }

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {

        if( ! sitemapWidget.hasDisplayState() ) {
            var item = sitemapWidget.getItem();
            if( item != null ) {
                return ! item.hasState();
            }
        }
        return false;
    }
}
*/