import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class CustomText extends Text {
    typedef Options as { 
        :text as Lang.String or Lang.ResourceId, 
        :color as Graphics.ColorType, 
        :backgroundColor as Graphics.ColorType, 
        :font as Graphics.FontType, 
        :justification as Graphics.TextJustification or Lang.Number, 
        :identifier as Lang.Object, 
        :locX as Lang.Numeric, 
        :locY as Lang.Numeric, 
        :width as Lang.Numeric, 
        :height as Lang.Numeric, 
        :visible as Lang.Boolean 
    };

    private var _text as String;
    private var _font as FontType;

    public function initialize( options as Options ) {
        _text = options[:text] as String;
        _font = options[:font] as FontType;
        Text.initialize( options );
    }
    public function draw( dc as Dc ) as Void {
        var dim = dc.getTextDimensions( _text, _font );
        if( locX instanceof Float && locX <= 1.0 ) {
            locX = dc.getWidth()*locX - dim[0]/2;
        }
        if( locY instanceof Float && locY <= 1.0 ) {
            locY = dc.getHeight()*locY - dim[1]/2;
        }
        Text.draw( dc );
    }
}