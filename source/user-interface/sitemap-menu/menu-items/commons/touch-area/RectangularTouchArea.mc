import Toybox.Lang;

class RectangularTouchArea extends TouchArea {

    private var _x1 as Number;
    private var _y1 as Number;
    private var _x2 as Number;
    private var _y2 as Number;

    public function initialize( 
        id as Symbol, 
        x as Number,
        y as Number,
        width as Number,
        height as Number ) 
    {
        TouchArea.initialize( id );
        _x1 = x;
        _y1 = y;
        _x2 = x + width;
        _y2 = y + height;
    }

    public function contains( coordinates as [Number, Number] ) as Boolean {
        return 
            ( coordinates[0] >= _x1 && coordinates[0] <= _x2 )
            &&
            ( coordinates[1] >= _y1 && coordinates[1] <= _y2 );
    }
}