import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * `BaseMenuItem` is the base class for all menu item classes.
 *
 * Its current role is to draw the focus indicator for devices that require it 
 * (such as the Edge 540/840). Additional shared functionality may be added 
 * here in the future.
 */

// Defines the options accepted by the `BaseMenuItem` class.
// Most of these options are used by `SitemapBaseMenuItem`.
typedef BaseMenuItemOptions as {
    :id as Object,
    :icon as ResourceId?,
    :label as String,
    :labelColor as ColorType?,
    :status as Drawable?,
};

class BaseMenuItem extends CustomMenuItem {
    
    // Constructor
    // This base class currently only uses the `id` from the options;
    // all other options are used by derived classes.
    protected function initialize( options as BaseMenuItemOptions ) {
        CustomMenuItem.initialize( options[:id] as String, {} );
    }

    
    // This class implements the `draw()` function and renders the common elements.
    // Additional drawing is delegated to `drawImpl()`, which must be implemented 
    // by subclasses.
    public function drawImpl( dc as Dc ) as Void {
        throw new AbstractMethodException( "BaseMenuItem.drawImpl" );
    }
    public function draw( dc as Dc ) as Void {
        // If the focused background color is not transparent and the item is focused, 
        // fill the background with the specified color.
        if( ( isFocused() ) && 
            Constants.UI_MENU_ITEM_BG_COLOR_FOCUSED != Graphics.COLOR_TRANSPARENT ) {
                dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_MENU_ITEM_BG_COLOR_FOCUSED );
                dc.clear();
        }
        drawImpl( dc );
    }
}