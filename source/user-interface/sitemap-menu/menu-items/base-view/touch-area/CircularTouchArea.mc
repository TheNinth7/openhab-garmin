import Toybox.Lang;
import Toybox.Math;

class CircularTouchArea extends TouchArea {

    private var _x as Number;
    private var _y as Number;
    private var _squareRadius as Number;

    public function initialize( 
        id as Symbol, 
        x as Number,
        y as Number,
        radius as Number ) 
    {
        TouchArea.initialize( id );
        _x = x;
        _y = y;
        _squareRadius = CustomMath.square( radius ).toNumber();
    }

    public function contains( coordinates as [Number, Number] ) as Boolean {
        return 
            (
                CustomMath.square( coordinates[0] - _x )
                + CustomMath.square( coordinates[1] - _y ) 
            )
            <= _squareRadius;
    }
}