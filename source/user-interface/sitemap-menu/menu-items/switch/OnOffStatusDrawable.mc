import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Drawable for rendering an on/off switch.
 *
 * This class uses a `BufferedBitmap` to obtain a `Dc` for drawing the switch
 * with primitive shapes (circles and rectangles). 
 * On CIQ versions prior to 4.0.0, it uses our custom `LegacyBufferedBitmap`; 
 * on 4.0.0 and above, it uses the standard `BufferedBitmap`.
 */

class OnOffStatusDrawable extends BufferedBitmapDrawable {
    
    // Height and width of the switch is defined relative to the menu item height
    private const HEIGHT = ( Constants.UI_MENU_ITEM_HEIGHT * 0.8 ).toNumber();
    private const WIDTH = ( Constants.UI_MENU_ITEM_HEIGHT * 0.45 ).toNumber();
    // The circles are again defines as a factor the the WIDTH defined above
    private const OUTER_CIRCLE_FACTOR = 0.8;
    private const INNER_CIRCLE_FACTOR = 0.75;

    // Constructor
    public function initialize( isEnabled as Boolean ) {
        BufferedBitmapDrawable.initialize( {
            :width => WIDTH,
            :height => HEIGHT,
        } );
        
        // Draws the switch
        setEnabled( isEnabled );
    }

    // Draws the switch UI element.
    // The outline is composed of two circles and a rectangle:
    // - Colored in openHAB orange when "on"
    // - Colored in light grey when "off"
    // A smaller black circle indicates the current on/off position.
    public function setEnabled( isEnabled as Boolean ) as Void {
        var dc = getBufferedBitmap().getDc();
        dc.clear();

        // Define the color of the switch
        if( isEnabled ) {
            dc.setColor( Constants.UI_COLOR_ACTIVE, Constants.UI_MENU_ITEM_BG_COLOR );
        } else {
            dc.setColor( Graphics.COLOR_LT_GRAY, Constants.UI_MENU_ITEM_BG_COLOR );
        }
        
        // Spacing defines the gap between the outer edge of the `Drawable` and the switch.
        // This is necessary because anti-aliasing can cause drawing primitives to slightly 
        // exceed their intended boundaries.
        var spacing = ( dc.getWidth() * (1-OUTER_CIRCLE_FACTOR) / 2 ).toNumber();
        // Radius of the upper and lower circles of the switch outline
        var radius = (dc.getWidth()/2).toNumber() - spacing;
        var xCenter = spacing + radius; // Horizontal center of the switch
        var upperYCenter = xCenter; // Center of the upper circle
        var lowerYCenter = dc.getHeight() - spacing - radius; // Center of the lower circle
        dc.setPenWidth( 1 );
        dc.setAntiAlias( true );
        dc.fillCircle( xCenter, upperYCenter, radius );
        dc.fillCircle( xCenter, lowerYCenter, radius );
        // Correction values -1 and + 3 have been determined by
        // trial and error and tested on different devices
        dc.fillRectangle( xCenter-radius-1, upperYCenter, radius*2 + 3, lowerYCenter - upperYCenter );

        // draw the inner circle showing the switch state
        dc.setColor( Constants.UI_COLOR_BACKGROUND, Constants.UI_MENU_ITEM_BG_COLOR );
        var toggleCenter = isEnabled ? upperYCenter : lowerYCenter;
        dc.fillCircle( xCenter, toggleCenter, radius * INNER_CIRCLE_FACTOR );
    }
}

/* Simple implementation for rendering the state as text
class OnOffStatusDrawable extends Text {
    public function initialize( isEnabled as Boolean ) {
        Text.initialize( {
            :text => getStatusText( isEnabled ),
            :font => Graphics.FONT_SMALL,
            :color => getColor( isEnabled ),
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        } );
    }
    public function setEnabled( isEnabled as Boolean ) as Void {
        setColor( getColor( isEnabled ) );
        setText( getStatusText( isEnabled ) );
    }
    private function getStatusText( isEnabled as Boolean ) as String {
        return isEnabled ? "ON" : "OFF";
    }
    private function getColor( isEnabled as Boolean ) as ColorType {
        return isEnabled ? 0xe64a19 : Constants.UI_COLOR_INACTIVE;
    }
}
*/