import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

/*
 * Prior to CIQ 4.0.0, `BufferedBitmap` lacked `getWidth()` and `getHeight()` methods,
 * making it incompatible with the `Bitmap` Drawable.
 * To handle this, we implement our own `BufferedBitmapDrawable` class,
 * which subclasses `Drawable` and accepts either a CIQ 4.0.0+ `BufferedBitmap`
 * or a `LegacyBufferedBitmap` for devices running earlier versions.
 *
 * NOTE: An initial workaround involved passing a `LegacyBufferedBitmap`
 * into a `Bitmap` Drawable. While this compiled and worked in the simulator,
 * it failed on real devices:
 * https://github.com/TheNinth7/ohg/issues/89
 */

// On older devices we use our own LegacyBufferedBitmap ...
(:exclForCiq400Plus)
typedef BufferedBitmapType as LegacyBufferedBitmap;
// ... and on newer ones the standard BufferedBitmap
(:exclForCiqPre400)
typedef BufferedBitmapType as BufferedBitmap;

class BufferedBitmapDrawable extends Drawable {

    private var _bufferedBitmap as BufferedBitmapType;
    public function getBufferedBitmap() as BufferedBitmapType {
        return _bufferedBitmap;
    }

    // Constructor
    // We use width and height from the buffered bitmap,
    // and pass everything else to the Drawable super class.
    public function initialize( options as BufferedBitmapOptions ) {
        _bufferedBitmap = createBufferedBitmap( options );
        Drawable.initialize( options );
    }

    // For CIQ < 4.0.0, this function creates a wrapper around `BufferedBitmap`
    // that adds the necessary functions to use it with a `BufferedBitmapDrawable`.
    (:exclForCiq400Plus)
    private function createBufferedBitmap( options as BufferedBitmapOptions ) as BufferedBitmapType {
        return new LegacyBufferedBitmap( options );
    }
    // For CIQ 4.0.0+, the BufferedBitmap provided by the SDK can be used
    // directly with the `BufferedBitmapDrawable`
    (:exclForCiqPre400)
    private function createBufferedBitmap( options as BufferedBitmapOptions ) as BufferedBitmapType {
        return Graphics.createBufferedBitmap( options ).get() as BufferedBitmap;
    }

    // Draws the buffered bitmap on a Dc.
    // locX and locY can be either absolute coordinates or layout constants.
    // If layout constants are used, we must compute the actual x/y drawing positions manually.
    public function draw( dc as Dc ) as Void {
        if( isVisible ) {
            var x = locX;
            var y = locY;

            // drawBitmap takes the coordinates of the upper/left
            // corner of the bitmap. x/y are computed accordingly
            if( x == WatchUi.LAYOUT_HALIGN_CENTER ) {
                x = dc.getWidth()/2 - width/2;
            } else if( x == WatchUi.LAYOUT_HALIGN_LEFT || x == WatchUi.LAYOUT_HALIGN_START ) {
                x = 0;
            } else if( x == WatchUi.LAYOUT_HALIGN_RIGHT ) {
                x = dc.getWidth() - width;
            }

            if( y == WatchUi.LAYOUT_VALIGN_CENTER ) {
                y = dc.getHeight()/2 - height/2;
            } else if( y == WatchUi.LAYOUT_VALIGN_TOP || y == WatchUi.LAYOUT_VALIGN_START ) {
                y = 0;
            } else if( y == WatchUi.LAYOUT_VALIGN_BOTTOM ) {
                x = dc.getHeight() - height;
            }

            dc.drawBitmap( x, y, _bufferedBitmap );
        }
    }
}