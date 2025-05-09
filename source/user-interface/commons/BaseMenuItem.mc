import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
    The BaseMenuItem is the super class of all menu item
    classes. Currently its own purpose is to draw the
    focus indicator for the few devices that need it
    (Edge 540/840) but in future there may be more functionality
    added here.
*/

// Defining the options accepted
// by this BaseMenuItem class
// Most of those options are used by the SitemapBaseMenuItem
typedef BaseMenuItemOptions as {
    :id as Object,
    :icon as ResourceId?,
    :label as String,
    :labelColor as ColorType?,
    :status as Drawable?,
    :parentMenu as CustomMenu?
};

class BaseMenuItem extends CustomMenuItem {
    
    // Constructor
    // This super class currently only uses the id from the options,
    // everything else is being used by derived classes
    protected function initialize( options as BaseMenuItemOptions ) {
        CustomMenuItem.initialize( options[:id] as String, {} );
    }

    
    // This class implements the draw function and draws the common
    // elements. Further drawing is delegated to drawImpl(), which is
    // to be implemented by derivates of this class.
    public function drawImpl( dc as Dc ) as Void {
        throw new AbstractMethodException( "BaseMenuItem.drawImpl" );
    }
    public function draw( dc as Dc ) as Void {
        // If the focused bg color is set to anything than transparent,
        // and the item is focused, we color the background
        if( ( isFocused() ) && 
            Constants.UI_MENU_ITEM_BG_COLOR_FOCUSED != Graphics.COLOR_TRANSPARENT ) {
                dc.setColor( Graphics.COLOR_WHITE, Constants.UI_MENU_ITEM_BG_COLOR_FOCUSED );
                dc.clear();
        }
        drawImpl( dc );
    }
}