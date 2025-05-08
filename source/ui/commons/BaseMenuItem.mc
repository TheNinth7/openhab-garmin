import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

typedef BaseMenuItemOptions as {
    :id as Object,
    :icon as ResourceId?,
    :label as String,
    :labelColor as ColorType?,
    :status as Drawable?,
    :parentMenu as CustomMenu?
};

class BaseMenuItem extends CustomMenuItem {
    protected function initialize( options as BaseMenuItemOptions ) {
        CustomMenuItem.initialize( options[:id] as String, {} );
    }

    public function drawImpl( dc as Dc ) as Void {
        throw new AbstractMethodException( "BaseMenuItem.drawImpl" );
    }

    public function draw( dc as Dc ) as Void {
        if( ( isFocused() ) && 
            Constants.UI_MENU_ITEM_BG_COLOR_FOCUSED != Graphics.COLOR_TRANSPARENT ) {
                System.println( "****** item in focus: " + getId() );
                dc.setColor( Graphics.COLOR_WHITE, Constants.UI_MENU_ITEM_BG_COLOR_FOCUSED );
                dc.clear();
        }
        drawImpl( dc );
    }

}