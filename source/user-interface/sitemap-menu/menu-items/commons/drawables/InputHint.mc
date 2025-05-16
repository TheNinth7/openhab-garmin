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

    private var _angle as Number;
    private var _color as ColorType;
    private var _icon as ResourceId?;

    public function initialize( key as Key, type as Type ) {
        Drawable.initialize( {} );
        _angle = Constants.UI_INPUT_HINT_ANGLES[key];
        _color = UI_INPUT_HINT_COLORS[type];
        _icon = UI_INPUT_HINT_ICONS[type];
    }

    public function draw( dc as Dc ) as Void {
        drawArc( dc );
        drawIcon( dc );
    }

    private function drawIcon( dc as Dc ) as Void {
        var icon = _icon;
        if( icon != null ) {
            var bitmap = WatchUi.loadResource( icon ) as BitmapReference;
            var bmWidth = bitmap.getWidth();
            var bmHeight = bitmap.getHeight();
            var diagonal = Math.sqrt(
                CustomMath.square( bmWidth )
                + CustomMath.square( bmHeight )
            ).toNumber();

            // Initialize coordinates
            var x = dc.getHeight() / 2;
            var y = dc.getWidth() / 2;
            // The distance from the screen center to the center of the hint
            var centerToCenter = x - LINE_WIDTH - ( diagonal / 2 * 1.1 ).toNumber();

            // Use trigonometry to calculate center position of the hint
            // Source for formulas: http://elsenaju.info/Rechnen/Trigonometrie.htm
            
            // For the Math functions, degrees need to be converted to radians
            var radian = Math.toRadians( _angle );
            y = y - centerToCenter * Math.sin( radian );
            x = x + centerToCenter * Math.cos( radian );

            x -= bmWidth/2;
            y -= bmHeight/2;

            dc.drawBitmap( x, y, bitmap );
        }
    }

    private function drawArc( dc as Dc ) as Void {
        // Anti-alias is only available in newer SDK versions
        if( dc has :setAntiAlias ) {
            dc.setAntiAlias( true );
        }
        
        // Calculate all parameters for the arc
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        var r = RADIUS;
        var from = _angle - LENGTH / 2;
        var to = _angle + LENGTH / 2;

        dc.setColor( _color, Constants.UI_COLOR_BACKGROUND );
        dc.setPenWidth( LINE_WIDTH );
        dc.drawArc( x, y, r, Graphics.ARC_COUNTER_CLOCKWISE, from, to );
    }
} 
