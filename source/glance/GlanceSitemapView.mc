import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Application.Properties;

(:glance) 
class GlanceSitemapView extends WatchUi.GlanceView {
    private var _sitemapRequest as GlanceSitemapRequest;
    private var _textArea as TextArea;

    public function initialize() {
        GlanceView.initialize();
        _sitemapRequest = new GlanceSitemapRequest();
        _textArea = new TextArea( { 
            :backgroundColor => Graphics.COLOR_TRANSPARENT,
            :font => [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE],
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        } );
    }


    public function onUpdate( dc as Dc ) as Void {
        if( _textArea.width == 0 ) {
            _textArea.setSize( dc.getWidth(), dc.getHeight() );
        }
        try {
            _textArea.setColor( Graphics.COLOR_WHITE );
            var sitemapHomepage = _sitemapRequest.getSitemapHomepage();
            if( sitemapHomepage != null ) {
                _textArea.setText( sitemapHomepage.label );
            } else {
                _textArea.setText( "openHAB" );
            }
        } catch( ex ) {
            _textArea.setColor( Graphics.COLOR_RED );
            var msg = ex.getErrorMessage();
            msg = msg != null ? msg : "Unknown error";
            _textArea.setText( msg );
        }
        _textArea.draw( dc );
    }

    public function onHide() as Void {
        _sitemapRequest.persist();
    }

}
