import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class OHApp extends Application.AppBase {
    private static var _sitemapRequest as SiteMapRequest;
    public static function getSitemapRequest() as SiteMapRequest {
        return _sitemapRequest;
    }

    public function initialize() {
        AppBase.initialize();
        _sitemapRequest = new SiteMapRequest( 0 );
    }


    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    public function onStop(state as Dictionary?) as Void {
        _sitemapRequest.stop();
    }

    // Return the initial view of your application here
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        var menu = _sitemapRequest.getMenu();
        if( menu != null ) {
            return [ menu, new PageMenuDelegate() ];
        } else {
            return [ new LoadingView() ];
        }
    }
}

function getApp() as OHApp {
    return Application.getApp() as OHApp;
}