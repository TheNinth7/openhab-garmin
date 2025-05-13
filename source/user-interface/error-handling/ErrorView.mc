import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

/*
 * View for displaying a full-screen error message resulting from an exception.
 *
 * It is implemented as a Singleton with static member functions responsible 
 * for displaying, updating, and hiding the error view.
 */
 class ErrorView extends WatchUi.View {

    // STATIC
    
    // _errorView only holds an error view as long as it is displayed
    private static var _errorView as ErrorView?;
    public static function isShowingErrorView() as Boolean {
        return _errorView != null;
    }
    
    /*
    * Retrieves the error view to display an error message.
    * If no error view is currently shown, a new one is created; 
    * otherwise, the existing view is updated.
    *
    * This function is used by `OHApp` for errors that occur during startup, 
    * as well as by the `showOrUpdate()` function below.
    */
    public static function createOrUpdate( ex as Exception ) as ErrorView {
        if( _errorView == null ) {
            Logger.debug( "ErrorView.createOrUpdate: creating error view" );
            _errorView = new ErrorView( ex );
        } else {
            _errorView.update( ex );
            Logger.debug( "ErrorView.createOrUpdate: updating error view" );
        }
        return _errorView as ErrorView;
    }

    /*
    * Call this function when a fatal error occurs that requires a full-screen error view.
    * If an error view is already displayed, it will be updated; otherwise, a new one 
    * will be created and shown.
    */
    public static function showOrUpdate( ex as Exception ) as Void {
        // We use the function above, and only if the error view
        // was not yet displayed switch to it
        var alreadyShowsErrorView = _errorView != null;
        createOrUpdate( ex );
        if( ! alreadyShowsErrorView ) {
            Logger.debug( "ErrorView.showOrUpdate: switching to error view" );
            ViewHandler.popToBottomAndSwitch( _errorView as ErrorView, null );
        }
    }

    /*
    * Call this function to replace the currently displayed error view with another view.
    * This is used, for example, by `WidgetSitemapRequest` when a subsequent request 
    * succeeds after a fatal error.
    */
    public static function replace( view as Views, delegate as InputDelegates or Null ) as Void {
        _errorView = null;
        ViewHandler.popToBottomAndSwitch( view, delegate );
    }

    // INSTANCE
    
    // The exception to be displayed
    private var _exception as Exception;

    // Constructor
    private function initialize( exception as Exception ) {
        View.initialize();
        _exception = exception;
    }

    /*
    * While the error view is active, toast notifications for non-fatal errors 
    * should be suppressed. 
    * See `ExceptionHandler` and `ToastHandler` for related logic.
    */
    public function onShow() as Void {
        ToastHandler.setUseToasts( false );
    }

    /*
    * While the error view is displayed, sitemap requests continue to run.
    * Any new errors that occur will update the content of the error view.
    */
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
