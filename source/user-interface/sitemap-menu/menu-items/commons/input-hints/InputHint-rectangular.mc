import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

(:exclForTouch :exclForScreenRound)
class InputHint extends BaseInputHint {

    private const HEIGHT as Number = 
        ( 0.2 * Constants.UI_SCREEN_HEIGHT ).toNumber(); // height of the indicator

    public const LINE_WIDTH as Number = 
        ( 0.030 * Constants.UI_SCREEN_WIDTH ).toNumber(); // line width is calculated proportionally to the screen width

    private var _x as Number;
    private var _yStart as Number;
    private var _yEnd as Number;

    public function initialize( key as BaseInputHint.Key, type as BaseInputHint.Type, touchId as Symbol? ) {
        BaseInputHint.initialize( key, type, touchId );
        _x = ( Constants.UI_SCREEN_WIDTH - LINE_WIDTH/2 ).toNumber();
        _yStart = ( _position - HEIGHT/2 ).toNumber();
        _yEnd = ( _position + HEIGHT/2 ).toNumber();
    }

    public function draw( dc as Dc ) as Void {
        // Anti-alias is only available in newer SDK versions
        if( dc has :setAntiAlias ) {
            dc.setAntiAlias( true );
        }
        
        dc.setColor( _color, Constants.UI_COLOR_BACKGROUND );
        dc.setPenWidth( LINE_WIDTH );
        dc.drawLine( _x, _yStart, _x, _yEnd );

        BaseInputHint.draw( dc );
    }
} 
