import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class OHApp extends Application.AppBase {

    public function initialize() {
        AppBase.initialize();
    }


    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    public function onStop(state as Dictionary?) as Void {
        SitemapRequest.stop();
        SitemapRequest.persist();
    }

    // Return the initial view of your application here
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        try {
            var menu = SitemapRequest.initializeFromStorage();
            SitemapRequest.start();
            if( menu != null ) {
                return [ menu, new PageMenuDelegate() ];
            } else {
                return [ new LoadingView() ];
            }
        } catch( ex ) {
            return [ new ErrorView( ex ) ];
        }
    }

    (:release) function onAppUpdate() as Void {
        Storage.clearValues();
    }
    (:release) function onSettingsChanged() as Void {
        Storage.clearValues();
    }

}

function getApp() as OHApp {
    return Application.getApp() as OHApp;
}