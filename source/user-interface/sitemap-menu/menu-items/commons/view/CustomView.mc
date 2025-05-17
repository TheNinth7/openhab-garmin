import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class CustomView extends View {

    public function initialize() {
        View.initialize();
    }

    private var _touchAreas as Array<TouchArea> = [];
    public function addTouchArea( ta as TouchArea ) as Void {
        _touchAreas.add( ta );
    }
    public function getTouchAreas() as Array<TouchArea> {
        return _touchAreas;
    }

    private var _drawables as Array<Drawable> = [];
    public function addDrawable( drawable as Drawable ) as Void {
        _drawables.add( drawable );
        if( drawable instanceof CustomBitmap ) {
            var touchArea = drawable.createTouchArea();
            if( touchArea != null ) {
                addTouchArea( touchArea );
            }
        }
    }

    public function draw( dc as Dc ) as Void {
        for( var i = 0; i < _drawables.size(); i++ ) {
            _drawables[i].draw( dc );
        }
    }
    
    public function onUpdate( dc as Dc ) as Void {
        Logger.debug(( "CustomView.onUpdate" ) );
        dc.clearClip();
        dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_COLOR_BACKGROUND );
        dc.clear();

        /*
        var dcHeight = dc.getHeight();
        var dcWidth = dc.getWidth();
        dc.drawRectangle( dcWidth * 0.25, dcHeight * 0.075, dcWidth * 0.5, dcHeight * 0.2 );
        */
        draw( dc );
    }

    (:exclForTouch)
    public function addInputHint( key as InputHint.Key, type as InputHint.Type, touchId as Symbol ) as Void {
        var inputHint = new InputHint( 
            key,
            type,
            touchId 
        );
        addDrawable( inputHint );
        var touchArea = inputHint.getTouchArea();
        if( touchArea != null ) {
            addTouchArea( touchArea );
        }
    }
}