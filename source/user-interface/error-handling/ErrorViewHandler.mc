import Toybox.Lang;
import Toybox.WatchUi;

class ErrorViewHandler {
    private static var _errorView as ErrorView?;
    
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

    public static function showOrUpdateErrorView( ex as Exception ) as Void {
        var alreadyShowsErrorView = _errorView != null;
        createOrUpdateErrorView( ex );
        if( ! alreadyShowsErrorView ) {
            Logger.debug( "ErrorViewHandler.showOrUpdateErrorView: switching to error view" );
            ViewHandler.popToBottomAndSwitch( _errorView as ErrorView, null );
        }
    }

    public static function isShowingErrorView() as Boolean {
        return _errorView != null;
    }

    public static function replaceErrorView( view as Views, delegate as InputDelegates or Null ) as Void {
        _errorView = null;
        ViewHandler.popToBottomAndSwitch( view, delegate );
    }

}