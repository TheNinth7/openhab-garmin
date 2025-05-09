import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This static singleton class is responsible for displaying, 
 * updating, and hiding the full-screen error view.
 */
class ErrorViewHandler {

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
    * as well as by the `showOrUpdateErrorView()` function below.
    */
    public static function createOrUpdateErrorView( ex as Exception ) as ErrorView {
        if( _errorView == null ) {
            Logger.debug( "ErrorViewHandler.createOrUpdateErrorView: creating error view" );
            _errorView = new ErrorView( ex );
        } else {
            _errorView.update( ex );
            Logger.debug( "ErrorViewHandler.createOrUpdateErrorView: updating error view" );
        }
        return _errorView as ErrorView;
    }

    /*
    * Call this function when a fatal error occurs that requires a full-screen error view.
    * If an error view is already displayed, it will be updated; otherwise, a new one 
    * will be created and shown.
    */
    public static function showOrUpdateErrorView( ex as Exception ) as Void {
        // We use the function above, and only if the error view
        // was not yet displayed switch to it
        var alreadyShowsErrorView = _errorView != null;
        createOrUpdateErrorView( ex );
        if( ! alreadyShowsErrorView ) {
            Logger.debug( "ErrorViewHandler.showOrUpdateErrorView: switching to error view" );
            ViewHandler.popToBottomAndSwitch( _errorView as ErrorView, null );
        }
    }

    /*
    * Call this function to replace the currently displayed error view with another view.
    * This is used, for example, by `WidgetSitemapRequest` when a subsequent request 
    * succeeds after a fatal error.
    */
    public static function replaceErrorView( view as Views, delegate as InputDelegates or Null ) as Void {
        _errorView = null;
        ViewHandler.popToBottomAndSwitch( view, delegate );
    }
}