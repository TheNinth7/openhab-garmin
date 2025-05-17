import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

(:exclForTouch)
class InputHint extends Drawable {

    private const RADIUS as Number = 
        ( 0.49 * Constants.UI_SCREEN_WIDTH ).toNumber(); // radius of the arc is calculated relative to the screen width
    private const LINE_WIDTH as Number = 
        ( 0.015 * Constants.UI_SCREEN_WIDTH ).toNumber(); // line width is calculated proportionally to the screen width
    private const LENGTH as Number = 20; // total length of the arc in degree

    enum Key {
        HINT_KEY_ENTER,
        HINT_KEY_BACK
    }
    enum Type {
        HINT_TYPE_NEUTRAL,
        HINT_TYPE_POSITIVE,
        HINT_TYPE_DESTRUCTIVE,
    }
    private const UI_INPUT_HINT_COLORS as Array<ColorType> = [
        Constants.UI_COLOR_TEXT,
        Constants.UI_COLOR_POSITIVE,
        Constants.UI_COLOR_DESTRUCTIVE
    ];
    private const UI_INPUT_HINT_ICONS as Array<ResourceId?> = [
        null,
        Rez.Drawables.iconCheckHint,
        Rez.Drawables.iconCancelHint
    ];

    private var _color as ColorType;
    private var _icon as InputHintIcon?;

    private var _xCenter as Number;
    private var _yCenter as Number;
    private var _arcRadius as Number;
    private var _arcFromAngle as Number;
    private var _arcToAngle as Number;

    public function initialize( key as Key, type as Type, touchId as Symbol? ) {
        Drawable.initialize( {} );
        var angle = Constants.UI_INPUT_HINT_ANGLES[key];
        _color = UI_INPUT_HINT_COLORS[type];
        var iconRez = UI_INPUT_HINT_ICONS[type];

        // Calculate all parameters for the arc
        _xCenter = ( Constants.UI_SCREEN_WIDTH / 2 ).toNumber();
        _yCenter = ( Constants.UI_SCREEN_HEIGHT / 2 ).toNumber();
        _arcRadius = RADIUS;
        _arcFromAngle = angle - LENGTH / 2;
        _arcToAngle = angle + LENGTH / 2;

        if( iconRez != null ) {
            _icon = new InputHintIcon( iconRez, touchId, angle, LINE_WIDTH );
        }
    }

    public function draw( dc as Dc ) as Void {
        drawArc( dc );
        if( _icon != null ) {
            _icon.draw( dc );
        }
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

    public function getTouchArea() as CircularTouchArea? {
        if( _icon != null ) {
            return _icon.getTouchArea();
        } else {
            return null;
        }
    }
} 
