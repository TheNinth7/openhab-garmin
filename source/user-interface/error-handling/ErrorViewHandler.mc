import Toybox.Lang;
import Toybox.WatchUi;

/*
    This (static) Singleton class is responsible for showing,
    updating and hiding the full-screen error view.
*/
class ErrorViewHandler {

    // _errorView only holds an error view as long as it is displayed
    private static var _errorView as ErrorView?;
    public static function isShowingErrorView() as Boolean {
        return _errorView != null;
    }
    
    // When an error occurs, this function can be used to obtain an
    // error view. It either creates a new one, or if one is displayed already,
    // it updates the existing one.
    // This function is used by OHApp for errors occuring already during startup
    // and by the showOrUpdateErrorView() function below
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

    // Call this function when an (fatal) error occurs for which a 
    // full-screen error view shall be shown.
    // If an error view is already displayed, it will update the error
    // view, otherwise it will create and show one.
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

    // Call this function if an error view is currently shown
    // and shall be replaced by another view. This is used by
    // the WidgetSitemapRequest, if after a fatal error a further
    // request was sucesssful.
    public static function replaceErrorView( view as Views, delegate as InputDelegates or Null ) as Void {
        _errorView = null;
        ViewHandler.popToBottomAndSwitch( view, delegate );
    }
}