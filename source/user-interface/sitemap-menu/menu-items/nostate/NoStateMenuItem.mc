import Toybox.Lang;
import Toybox.WatchUi;

class NoStateMenuItem extends BaseSitemapMenuItem {
    
    // The text status Drawable
    private var _text as Text;

    // Constructor
    public function initialize( sitemapPrimitiveElement as SitemapPrimitiveElement ) {
        _text = new Text( { 
            :text => "—", 
            :color => Graphics.COLOR_LT_GRAY,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
            :font => Constants.UI_MENU_ITEM_FONTS[0],
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        } );
        BaseSitemapMenuItem.initialize(
            {
                :id => sitemapPrimitiveElement.id,
                :label => sitemapPrimitiveElement.label,
                :status => _text
            }
        );
    }

    // Updates the menu item
    public function update( sitemapElement as SitemapElement ) as Boolean {
        return true;
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return 
            sitemapElement instanceof SitemapPrimitiveElement
            && (
                ( !sitemapElement.hasItemState() && !sitemapElement.hasWidgetState() )
                || ! sitemapElement.isStateFresh
            );
    }
}
