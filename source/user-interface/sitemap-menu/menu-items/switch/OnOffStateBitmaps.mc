import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Singleton class that provides two BufferedBitmaps representing
 * a toggle switch in the "on" and "off" positions.
 *
 * Each BufferedBitmap is used to obtain a corresponding Dc (Drawing Context),
 * allowing the switch to be rendered using primitive shapes such as circles and rectangles.
 */
class OnOffStateBitmaps {
    
    // Singleton accessor
    private static var _instance as OnOffStateBitmaps?;
    public static function get() as OnOffStateBitmaps {
        if( _instance == null ) {
            _instance = new OnOffStateBitmaps();
        }
        return _instance as OnOffStateBitmaps;
    }

    // Height and width of the switch is defined relative to the menu item height
    public var HEIGHT as Number = ( Constants.UI_MENU_ITEM_HEIGHT * 0.8 ).toNumber();
    public var WIDTH as Number = ( Constants.UI_MENU_ITEM_HEIGHT * 0.45 ).toNumber();
    
    // The circles are again defines as a factor the the WIDTH defined above
    private const OUTER_CIRCLE_FACTOR = 0.8;
    private const INNER_CIRCLE_FACTOR = 0.75;

    // The BufferedBitmaps for ON and OFF
    public var on as BufferedBitmapType;
    public var off as BufferedBitmapType;

    // Constructor
    public function initialize() {
        on = BufferedBitmapFactory.createBufferedBitmap( {
            :width => WIDTH,
            :height => HEIGHT,
        } );
        draw( on, true );

        off = BufferedBitmapFactory.createBufferedBitmap( {
            :width => WIDTH,
            :height => HEIGHT,
        } );
        draw( off, false );
    }

    // Draws the switch UI element.
    // The outline is composed of two circles and a rectangle:
    // - Colored in openHAB orange when "on"
    // - Colored in light grey when "off"
    // A smaller black circle indicates the current on/off position.
    protected function draw( bufferedBitmap as BufferedBitmapType, isEnabled as Boolean ) as Void {
        var dc = bufferedBitmap.getDc();
        dc.clear();

        // Define the color of the switch
        if( isEnabled ) {
            //dc.setColor( Constants.UI_COLOR_ACTIVE, Constants.UI_MENU_ITEM_BG_COLOR );
            dc.setFill( 0xFF000000 + Constants.UI_COLOR_ACTIVE );
        } else {
            //dc.setColor( Graphics.COLOR_LT_GRAY, Constants.UI_MENU_ITEM_BG_COLOR );
            dc.setFill( 0xFF000000 + Graphics.COLOR_LT_GRAY );
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
        //dc.setColor( Constants.UI_COLOR_BACKGROUND, Constants.UI_MENU_ITEM_BG_COLOR );
        dc.setFill( 0xFF000000 + Graphics.COLOR_BLACK );
        var toggleCenter = isEnabled ? upperYCenter : lowerYCenter;
        dc.fillCircle( xCenter, toggleCenter, radius * INNER_CIRCLE_FACTOR );
    }
}