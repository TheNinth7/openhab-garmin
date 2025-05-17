import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

(:exclForTouch :exclForScreenRectangular)
class InputHintIcon extends Bitmap {

    private var _touchArea as CircularTouchArea?;

    public function getTouchArea() as CircularTouchArea? {
        return _touchArea;
    }
    
    public function initialize( 
        icon as ResourceId,
        touchId as Symbol?, 
        angle as Number, 
        lineWidth as Number ) 
    {
        Bitmap.initialize( {
            :rezId => icon
        } );

        var diagonal = Math.sqrt(
            CustomMath.square( width )
            + CustomMath.square( height )
        ).toNumber();

        // Initialize coordinates
        var xCenterIcon = ( Constants.UI_SCREEN_WIDTH / 2 ).toNumber();
        var yCenterIcon = ( Constants.UI_SCREEN_HEIGHT / 2 ).toNumber();
        // The distance from the screen center to the center of the icon
        var centerToCenter = xCenterIcon - lineWidth - ( diagonal / 2 * 1.1 ).toNumber();

        // Use trigonometry to calculate center position of the hint
        // Source for formulas: http://elsenaju.info/Rechnen/Trigonometrie.htm
        
        // For the Math functions, degrees need to be converted to radians
        var radian = Math.toRadians( angle );
        xCenterIcon = xCenterIcon + centerToCenter * Math.cos( radian );
        yCenterIcon = yCenterIcon - centerToCenter * Math.sin( radian );

        locX = ( xCenterIcon - width/2 ).toNumber();
        locY = ( yCenterIcon - height/2 ).toNumber();

        if( touchId != null ) {
            _touchArea = new CircularTouchArea( 
                touchId, 
                xCenterIcon.toNumber(), 
                yCenterIcon.toNumber(), 
                ( diagonal * 0.75 ).toNumber()
            );
        }
    }
} 
