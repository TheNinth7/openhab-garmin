import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;

class ErrorView extends WatchUi.View {

    private var _exception as Exception;

    public function initialize( exception as Exception ) {
        View.initialize();
        _exception = exception;
    }

    public function onUpdate( dc as Dc ) as Void {
        dc.setColor( Graphics.COLOR_RED, Graphics.COLOR_BLACK );
        dc.clear();
        var text = _exception.getErrorMessage();
        text = ( text == null || text.equals( "" ) ) ? "Unknown Exception" : text; 
        var width = dc.getWidth() / Math.sqrt( 2 );
        new TextArea( {
            :text => text,
            :font => [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY],
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :color => Graphics.COLOR_RED,
            :backgroundColor => Graphics.COLOR_BLACK,
            :width => width,
            :height => width
        } ).draw( dc );
    }
}
