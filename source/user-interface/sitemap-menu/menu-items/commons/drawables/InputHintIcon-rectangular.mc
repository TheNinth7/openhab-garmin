import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

(:exclForTouch :exclForScreenRound)
class InputHintIcon extends Bitmap {

    private var _touchArea as CircularTouchArea?;

    public function getTouchArea() as CircularTouchArea? {
        return _touchArea;
    }
    
    public function initialize( 
        icon as ResourceId,
        touchId as Symbol?, 
        position as Number, 
        lineWidth as Number ) 
    {
        Bitmap.initialize( {
            :rezId => icon
        } );

        locX = Constants.UI_SCREEN_WIDTH - lineWidth*2 - width;
        locY = ( position - height/2 ).toNumber();

        if( touchId != null ) {
            _touchArea = new CircularTouchArea( 
                touchId, 
                ( locX + width/2 ).toNumber(), 
                position, 
                ( width*2 ).toNumber()
            );
        }
    }
} 
