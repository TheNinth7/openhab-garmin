import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Custom views provide specialized controls for specific widgets or item types.
 * This is the base class for all custom views. It maintains a list of Drawables
 * that compose the custom view, and a list of touch areas associated with actions.
 *
 * Subclasses should use addDrawable() to define their layout—ideally within onLayout().
 *
 * Subclasses can override onUpdate(), but should call the superclass implementation
 * to ensure the Drawables are properly rendered.
 *
 * Use addTouchArea() to define areas that trigger actions when tapped 
 * (see CustomBehaviorDelegate). If a CustomBitmap with a touch area is added,
 * the area is automatically included.
 *
 * Subclasses can also use addInputHint() to display input hints on button-based devices—
 * indicators showing which buttons perform which actions.
 */
class CustomView extends View {

    // Constructor
    public function initialize() {
        View.initialize();
    }

    // The list of Drawables
    private var _drawables as Array<Drawable> = [];
    
    // Add a Drawable
    public function addDrawable( drawable as Drawable ) as Void {
        _drawables.add( drawable );
        // If this is a CustomBitmap with a defined touch area,
        // add its touch area to the list
        if( drawable instanceof CustomBitmap ) {
            var touchArea = drawable.createTouchArea();
            if( touchArea != null ) {
                addTouchArea( touchArea );
            }
        }
    }

    // Draw all Drawables
    public function draw( dc as Dc ) as Void {
        for( var i = 0; i < _drawables.size(); i++ ) {
            _drawables[i].draw( dc );
        }
    }
    
    // Clear the Dc and draw all Drawables    
    public function onUpdate( dc as Dc ) as Void {
        // Logger.debug( "CustomView.onUpdate: start" );

        // We need to clear the clip, because there is bug in Garmin SDK,
        // with a clip in the menu title setting a clip in subsequent views
        // being displayed. See here for more details:
        // https://github.com/TheNinth7/ohg/issues/81
        dc.clearClip();

        dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_COLOR_BACKGROUND );
        dc.clear();

        draw( dc );
        // Logger.debug( "CustomView.onUpdate: end" );
    }

    // Touch areas with accessors
    private var _touchAreas as Array<TouchArea> = [];
    public function addTouchArea( ta as TouchArea ) as Void {
        _touchAreas.add( ta );
    }
    public function getTouchAreas() as Array<TouchArea> {
        return _touchAreas;
    }

    // Add an input hint
    // Key identifies for which key (enter or back) the hint shall be displayed
    // Type defines the color and icon
    // Set touchId to associate the input hint icon with a touch behavior
    (:exclForTouch)
    public function addInputHint( key as BaseInputHint.Key, type as BaseInputHint.Type, touchId as Symbol ) as Void {
        var inputHint = new InputHint( 
            key,
            type,
            touchId 
        );
        addDrawable( inputHint );
        // The input hint will associate the touchId with a
        // touch area, but ONLY IF it has an icon
        var touchArea = inputHint.getTouchArea();
        if( touchArea != null ) {
            addTouchArea( touchArea );
        }
    }
}