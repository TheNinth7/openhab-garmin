import Toybox.Lang;
import Toybox.Graphics;

class TextDimensions {
    private static var _bufferedBitmap as BufferedBitmap?;
    
    private static function get() as BufferedBitmap {
        if( _bufferedBitmap == null ) {
            var options = { :width => 1, :height => 1 };
            if( Graphics has :createBufferedBitmap ) {
                // CIQ >= 4 uses a graphics pool and resource references
                _bufferedBitmap = Graphics.createBufferedBitmap( options ).get() as BufferedBitmap;
            } else {
                // CIQ < 4 creates buffered bitmaps in the app heap
                _bufferedBitmap = new BufferedBitmap( options );
            }
        }
        return _bufferedBitmap as BufferedBitmap;
    }
    
    // Use the real Dc from the buffered bitmap to determine the text width
    public static function getTextWidthInPixels( text as String, font as FontType ) as Number {
        return get().getDc().getTextWidthInPixels( text, font );
    }

    public static function getWidthRatio( text1 as String, text2 as String ) as Float {
        var len1 = getTextWidthInPixels( text1, Graphics.FONT_MEDIUM );
        var len2 = getTextWidthInPixels( text2, Graphics.FONT_MEDIUM );
        return len1.toFloat()/(len1.toFloat()+len2.toFloat());
    }
}