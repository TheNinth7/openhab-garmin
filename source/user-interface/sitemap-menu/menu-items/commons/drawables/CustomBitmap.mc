import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;

class CustomBitmap extends Bitmap {
    typedef Options as { 
        :rezId as Lang.ResourceId, 
        :bitmap as Graphics.BitmapType, 
        :identifier as Lang.Object, 
        :locX as Lang.Numeric, 
        :locY as Lang.Numeric, 
        :width as Lang.Numeric, 
        :height as Lang.Numeric, 
        :visible as Lang.Boolean,
        :touchId as Symbol?
    };

    private var _touchId as Symbol?;

    public function initialize( options as Options ) {
        Bitmap.initialize( options );
        _touchId = options[:touchId];
    }
    public function draw( dc as Dc ) as Void {
        if( locX instanceof Float && locX <= 1.0 ) {
            locX = dc.getWidth()*locX - width/2;
        }
        if( locY instanceof Float && locY <= 1.0 ) {
            locY = dc.getHeight()*locY - height/2;
        }
        Bitmap.draw( dc );
    }

    public function createTouchArea() as CircularTouchArea? {
        if( _touchId == null ) {
            return null;
        } else {
            var x = locX;
            if( x instanceof Float && x <= 1.0 ) {
                x = System.getDeviceSettings().screenWidth*x;
            } else {
                x += width/2;
            }

            var y = locY;
            if( y instanceof Float && y <= 1.0 ) {
                y = System.getDeviceSettings().screenHeight*y;
            } else {
                y += height/2;
            }

            return new CircularTouchArea( 
                _touchId as Symbol, 
                x.toNumber(), 
                y.toNumber(), 
                ( width*1.5 ).toNumber() 
            );
        }
    }
}