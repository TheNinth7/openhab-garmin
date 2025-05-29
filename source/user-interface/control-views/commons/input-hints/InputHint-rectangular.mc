import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * InputHint implementation for rectangular, button-based devices,
 * specifically the Edge 540 and 840.
 *
 * This class draws a vertical line next to the corresponding button,
 * and, depending on the hint type, may also include an icon.
 *
 * NOTE: On the Edge 540 and 840, the ENTER button is partially located
 * above the screen area controlled by the app, so the indicator may appear
 * slightly misaligned.
 */
(:exclForTouch :exclForScreenRound)
class InputHint extends BaseInputHint {

    private const HEIGHT as Number = 
        ( 0.2 * Constants.UI_SCREEN_HEIGHT ).toNumber(); // height of the indicator

    public const LINE_WIDTH as Number = 
        ( 0.020 * Constants.UI_SCREEN_WIDTH ).toNumber(); // line width is calculated proportionally to the screen width

    // The coordinates for the line
    private var _x as Number;
    private var _yStart as Number;
    private var _yEnd as Number;

    public function initialize( key as BaseInputHint.Key, type as BaseInputHint.Type, touchId as Symbol? ) {
        BaseInputHint.initialize( key, type, touchId );
        
        // prepare the coordinates
        // the _condition from the Constants
        // identifies the middle of the vertical line
        _x = ( Constants.UI_SCREEN_WIDTH - LINE_WIDTH/2 ).toNumber();
        _yStart = ( _position - HEIGHT/2 ).toNumber();
        _yEnd = ( _position + HEIGHT/2 ).toNumber();
    }

    // Draw the line
    public function draw( dc as Dc ) as Void {
        // Anti-alias is only available in newer SDK versions
        if( dc has :setAntiAlias ) {
            dc.setAntiAlias( true );
        }
        
        dc.setColor( _color, Constants.UI_COLOR_BACKGROUND );
        dc.setPenWidth( LINE_WIDTH );
        dc.drawLine( _x, _yStart, _x, _yEnd );

        // Draw the icon
        BaseInputHint.draw( dc );
    }
} 
