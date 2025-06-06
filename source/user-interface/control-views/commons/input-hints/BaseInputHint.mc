import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * Base class for input hints.
 * There are two sub classes, one for round-shaped screens, and
 * one for rectangular screens. Both are called InputHint, and the
 * correct one is choosen via exclude annotations in monkey.jungle.
 */
(:exclForTouch)
class BaseInputHint extends Drawable {

    // Enum for type of key
    // The positions for each key are defined in 
    // DefaultConstants/Constants, since they are 
    // device-specific
    enum Key {
        HINT_KEY_ENTER,
        HINT_KEY_BACK
    }
    // Enum for type of input hint
    // NEUTRAL = white
    // POSITIVE = green, with check icon
    // DESTRUCTIVE = red, with cancel icon
    enum Type {
        HINT_TYPE_NEUTRAL,
        HINT_TYPE_CHECK,
        HINT_TYPE_CANCEL,
        HINT_TYPE_STOP,
    }
    // Association of Type with colors
    private const UI_INPUT_HINT_COLORS as Array<ColorType> = [
        Constants.UI_COLOR_TEXT,
        Constants.UI_COLOR_TEXT,
        Constants.UI_COLOR_TEXT,
        Constants.UI_COLOR_TEXT
    ];
    // Association of Type with icons
    private const UI_INPUT_HINT_ICONS as Array<ResourceId?> = [
        null,
        Rez.Drawables.iconCheckHint,
        Rez.Drawables.iconCancelHint,
        Rez.Drawables.iconStopHint
    ];

    // Default line width
    public const LINE_WIDTH as Number = 
        ( 0.0125 * Constants.UI_SCREEN_WIDTH ).toNumber(); // line width is calculated proportionally to the screen width

    protected var _position as Number; // The position (angle for round, y coordinate for rectangular)
    protected var _color as ColorType;
    private var _icon as InputHintIcon?;

    // Initialize the members above
    protected function initialize( key as Key, type as Type, touchId as Symbol? ) {
        Drawable.initialize( {} );
        _position = Constants.UI_INPUT_HINT_POSITIONS[key];
        _color = UI_INPUT_HINT_COLORS[type];
        
        // For the icon we initialize the InputHintIcon, for which
        // again there are two versions for round and rectangular screen
        var iconRez = UI_INPUT_HINT_ICONS[type];
        if( iconRez != null ) {
            _icon = new InputHintIcon( iconRez, touchId, _position, LINE_WIDTH );
        }
    }

    // Subclasses should implement their own draw() and
    // call this draw for drawing the icon
    public function draw( dc as Dc ) as Void {
        if( _icon != null ) {
            _icon.draw( dc );
        }
    }

    // Return the touch area associated with this
    // input hint, if there is any
    public function getTouchArea() as CircularTouchArea? {
        if( _icon != null ) {
            return _icon.getTouchArea();
        } else {
            return null;
        }
    }
} 
