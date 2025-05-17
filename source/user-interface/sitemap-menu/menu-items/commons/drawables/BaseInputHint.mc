import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

(:exclForTouch)
class BaseInputHint extends Drawable {

    public const LINE_WIDTH as Number = 
        ( 0.015 * Constants.UI_SCREEN_WIDTH ).toNumber(); // line width is calculated proportionally to the screen width

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

    protected var _position as Number;
    protected var _color as ColorType;
    private var _icon as InputHintIcon?;

    protected function initialize( key as Key, type as Type, touchId as Symbol? ) {
        Drawable.initialize( {} );
        _position = Constants.UI_INPUT_HINT_POSITIONS[key];
        _color = UI_INPUT_HINT_COLORS[type];
        var iconRez = UI_INPUT_HINT_ICONS[type];
        if( iconRez != null ) {
            _icon = new InputHintIcon( iconRez, touchId, _position, LINE_WIDTH );
        }
    }

    public function draw( dc as Dc ) as Void {
        if( _icon != null ) {
            _icon.draw( dc );
        }
    }

    public function getTouchArea() as CircularTouchArea? {
        if( _icon != null ) {
            return _icon.getTouchArea();
        } else {
            return null;
        }
    }
} 
