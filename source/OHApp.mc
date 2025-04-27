import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class OHApp extends Application.AppBase {
    private var _SitemapRequest as SitemapRequest?;

    public function initialize() {
        AppBase.initialize();
    }


    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    public function onStop(state as Dictionary?) as Void {
        if( _SitemapRequest != null ) {
            _SitemapRequest.stop();
        }
    }

    // Return the initial view of your application here
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        try {
            SitemapRequest.start();
            var menu = SitemapRequest.getMenu();
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