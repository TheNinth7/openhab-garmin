import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

(:exclForCiq400Plus)
class OnOffBufferedBitmap extends BufferedBitmap {
    private var _height as Number;
    private var _width as Number;
    public function initialize( options as { :width as Lang.Number, :height as Lang.Number, :palette as Lang.Array<Graphics.ColorType>, :colorDepth as Lang.Number, :bitmapResource as WatchUi.BitmapResource, :alphaBlending as Graphics.AlphaBlending } ) {
        BufferedBitmap.initialize( options );
        _height = options[:height] as Number;
        _width = options[:width] as Number;
    }
    public function getHeight() as Number {
        return _height;        
    }
    public function getWidth() as Number {
        return _width;
    }
}

class OnOffStatusDrawable extends Bitmap {
    
    private var _bufferedBitmap as BufferedBitmap;

    private const HEIGHT = ( Constants.UI_MENU_ITEM_HEIGHT * 0.8 ).toNumber();
    private const WIDTH = ( Constants.UI_MENU_ITEM_HEIGHT * 0.45 ).toNumber();
    private const OUTER_CIRCLE_FACTOR = 0.8;
    private const INNER_CIRCLE_FACTOR = 0.75;

    public function initialize( isEnabled as Boolean ) {
        var options = {
            :width => WIDTH,
            :height => HEIGHT,
        };

        if( Graphics has :createBufferedBitmap ) {
            _bufferedBitmap = Graphics.createBufferedBitmap( options ).get() as BufferedBitmap;
        } else {
            _bufferedBitmap = createOnOffBufferedBitmap( options );
        }
        
        Bitmap.initialize( {
            :bitmap => _bufferedBitmap
        } );

        setEnabled( isEnabled );
    }

    (:exclForCiq400Plus)
    private function createOnOffBufferedBitmap(  options as { :width as Lang.Number, :height as Lang.Number, :palette as Lang.Array<Graphics.ColorType>, :colorDepth as Lang.Number, :bitmapResource as WatchUi.BitmapResource, :alphaBlending as Graphics.AlphaBlending } ) as OnOffBufferedBitmap {
        return new OnOffBufferedBitmap( options );
    }
    (:exclForCiqPre400)
    private function createOnOffBufferedBitmap(  options as { :width as Lang.Number, :height as Lang.Number, :palette as Lang.Array<Graphics.ColorType>, :colorDepth as Lang.Number, :bitmapResource as WatchUi.BitmapResource, :alphaBlending as Graphics.AlphaBlending } ) as OnOffBufferedBitmap {
        throw new GeneralException( "Device is CiqPre400, but has no Graphics.createBufferedBitmap" );
    }

    public function setEnabled( isEnabled as Boolean ) as Void {
        var dc = _bufferedBitmap.getDc();
        dc.clear();

        if( isEnabled ) {
            dc.setColor( 0xe64a19, Graphics.COLOR_BLACK );
            // dc.setFill( 0xe64a19 );
        } else {
            dc.setColor( Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK );
            // dc.setFill( Graphics.COLOR_LT_GRAY );
        }
        
        var spacing = ( dc.getWidth() * (1-OUTER_CIRCLE_FACTOR) / 2 ).toNumber();
        var radius = (dc.getWidth()/2).toNumber() - spacing;
        var xCenter = spacing + radius;
        var upperYCenter = xCenter;
        var lowerYCenter = dc.getHeight() - spacing - radius;
        dc.setPenWidth( 1 );
        dc.setAntiAlias( true );
        dc.fillCircle( xCenter, upperYCenter, radius );
        dc.fillCircle( xCenter, lowerYCenter, radius );
        // Correction values -1 and + 3 have been determined by
        // trial and error and tested on different devices
        dc.fillRectangle( xCenter-radius-1, upperYCenter, radius*2 + 3, lowerYCenter - upperYCenter );

        dc.setColor( Graphics.COLOR_BLACK, Graphics.COLOR_BLACK );
        // dc.setFill( Graphics.COLOR_BLACK );

        var toggleCenter = isEnabled ? upperYCenter : lowerYCenter;
        dc.fillCircle( xCenter, toggleCenter, radius * INNER_CIRCLE_FACTOR );
    }
}
/* Simpler version showing ON and OFF as text
class OnOffStatusDrawable extends Text {
    public function initialize( isEnabled as Boolean ) {
        Text.initialize( {
            :text => getStatusText( isEnabled ),
            :font => Graphics.FONT_SMALL,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        } );
    }
    public function setEnabled( isEnabled as Boolean ) as Void {
        setText( getStatusText( isEnabled ) );
    }
    private function getStatusText( isEnabled as Boolean ) as String {
        return isEnabled ? "ON" : "OFF";
    }
}
*/