import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Application.Properties;

/*
 * The glance view of the app.
 */
(:glance) 
class GlanceSitemapView extends WatchUi.GlanceView {
    
    // Glance shows a single text area
    private var _textArea as TextArea;

    // Constructor
    public function initialize() {
        GlanceView.initialize();
        
        // Initialize the text area
        // Width and height can only be set once a Dc is available
        _textArea = new TextArea( { 
            :backgroundColor => Graphics.COLOR_TRANSPARENT,
            :font => GlanceConstants.UI_GLANCE_FONTS,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        } );
    }


    public function onUpdate( dc as Dc ) as Void {
        // If size has not been set yet, then set it
        if( _textArea.width == 0 ) {
            _textArea.setSize( dc.getWidth(), dc.getHeight() );
        }
        try {
            // Display either the homepage label or if not a default
            _textArea.setColor( Graphics.COLOR_WHITE );
            var label = SitemapStore.getLabel();
            if( label != null ) {
                _textArea.setText( label );
            } else {
                _textArea.setText( "openHAB" );
            }
        } catch( ex ) {
            // Show any errors
            // Note that communication errors are caught by the sitemap
            // request but not consumed here, instead they are ignored
            _textArea.setColor( Graphics.COLOR_RED );
            var msg = ex.getErrorMessage();
            msg = msg != null ? msg : "Unknown error";
            _textArea.setText( msg );
        }
        _textArea.draw( dc );
    }
}
