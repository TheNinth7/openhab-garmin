import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class OHApp extends Application.AppBase {
    private var _sitemapRequest as SiteMapRequest?;

    public function initialize() {
        AppBase.initialize();
    }


    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    public function onStop(state as Dictionary?) as Void {
        if( _sitemapRequest != null ) {
            _sitemapRequest.stop();
        }
    }

    // Return the initial view of your application here
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        try {
            _sitemapRequest = new SiteMapRequest();
            var menu = _sitemapRequest.getMenu();
            if( menu != null ) {
                return [ menu, new PageMenuDelegate() ];
            } else {
                return [ new LoadingView() ];
            }
        } catch( ex ) {
            return [ new ErrorView( ex ) ];
        }
    }
}

function getApp() as OHApp {
    return Application.getApp() as OHApp;
}