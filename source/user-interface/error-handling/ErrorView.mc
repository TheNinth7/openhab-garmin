import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

/*
    View to display a full-screen error message from an exception
*/
class ErrorView extends WatchUi.View {

    // The exception to be displayed
    private var _exception as Exception;

    // Constructor
    public function initialize( exception as Exception ) {
        View.initialize();
        _exception = exception;
    }

    // While the error view is active, no toast notifications for
    // non-fatal errors should be displayed (see ExceptionHandler
    // and ToastHandler)
    public function onShow() as Void {
        ToastHandler.setUseToasts( false );
    }

    // When the error view is displayed, sitemap requests
    // continue, and any new errors update the error view
    public function update( exception as Exception ) as Void {
        _exception = exception;
        WatchUi.requestUpdate();
    }

    // Draw the error
    public function onUpdate( dc as Dc ) as Void {
        Logger.debug( "ErrorView.onUpdate" );
        
        // We need to clear the clip, because there is bug in Garmin SDK,
        // with a clip in the menu title setting a clip in subsequent views
        // being displayed. See here for more details:
        // https://github.com/TheNinth7/ohg/issues/81
        dc.clearClip();
        
        // Set the colors
        dc.setColor( Graphics.COLOR_RED, Graphics.COLOR_BLACK );
        dc.clear();

        // Define the error message
        var text = _exception.getErrorMessage();
        text = ( text == null || text.equals( "" ) ) ? "Unknown Exception" : text; 

        // Dimensions of the text area
        // Start with the full rectangle Dc ...
        var width = dc.getWidth();
        var height = dc.getHeight();

        // ... and for round screens, adapt it to the
        // largest square fitting into the circle
        if( System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND ) {
            width = width / Math.sqrt( 2 );
            height = width;
        }
        
        // Create the textarea and draw it.
        // The TextArea could also be created only once and reused,
        // but let's say for error handling performance is not critical.
        // The first opening of the error view would need to create it anyway
        // and for subsequent updates it does not really matter how fast they are
        new TextArea( {
            :text => text,
            :font => Constants.UI_ERROR_FONTS,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :color => Graphics.COLOR_RED,
            :backgroundColor => Graphics.COLOR_BLACK,
            :width => width,
            :height => height
        } ).draw( dc );
    }
}
