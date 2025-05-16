import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class TestDrawable extends Bitmap {

    public function initialize() {
        Bitmap.initialize( {
            :rezId => Rez.Drawables.iconCheck,
        } );
    }

    public function draw( dc as Dc ) as Void {
        dc.setColor( Constants.UI_COLOR_TEXT, Graphics.COLOR_RED );
        dc.clear();
        Bitmap.draw( dc );
    }
}

