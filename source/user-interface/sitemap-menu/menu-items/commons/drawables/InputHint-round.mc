import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

(:exclForTouch :exclForScreenRectangular)
class InputHint extends BaseInputHint {

    private const RADIUS as Number = 
        ( 0.49 * Constants.UI_SCREEN_WIDTH ).toNumber(); // radius of the arc is calculated relative to the screen width
    private const LENGTH as Number = 20; // total length of the arc in degree

    private var _xCenter as Number;
    private var _yCenter as Number;
    private var _arcRadius as Number;
    private var _arcFromAngle as Number;
    private var _arcToAngle as Number;

    public function initialize( key as BaseInputHint.Key, type as BaseInputHint.Type, touchId as Symbol? ) {
        BaseInputHint.initialize( key, type, touchId );

        // Calculate all parameters for the arc
        _xCenter = ( Constants.UI_SCREEN_WIDTH / 2 ).toNumber();
        _yCenter = ( Constants.UI_SCREEN_HEIGHT / 2 ).toNumber();
        _arcRadius = RADIUS;
        _arcFromAngle = _position - LENGTH / 2;
        _arcToAngle = _position + LENGTH / 2;
    }

    public function draw( dc as Dc ) as Void {
        drawArc( dc );
        BaseInputHint.draw( dc );
    }

    private function drawArc( dc as Dc ) as Void {
        // Anti-alias is only available in newer SDK versions
        if( dc has :setAntiAlias ) {
            dc.setAntiAlias( true );
        }
        
        dc.setColor( _color, Constants.UI_COLOR_BACKGROUND );
        dc.setPenWidth( LINE_WIDTH );
        dc.drawArc( _xCenter, _yCenter, _arcRadius, Graphics.ARC_COUNTER_CLOCKWISE, _arcFromAngle, _arcToAngle );
    }
} 
