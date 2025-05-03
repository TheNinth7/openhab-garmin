import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

(:glance)
class OHApp extends Application.AppBase {

    private var _glanceView as GlanceSitemapView?;

    public function initialize() {
        AppBase.initialize();
    }


    // onStart() is called on application start up
    public function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    (:typecheck(disableGlanceCheck))
    public function onStop(state as Dictionary?) as Void {
        Logger.debug( "OHApp.onStop" );
        SitemapStore.persist();
        SitemapErrorCountStore.persist();
    }

    // Return the initial view of your application here
    (:typecheck(disableGlanceCheck))
    public function getInitialView() as [Views] or [Views, InputDelegates] {
        try {
            var menu = SitemapRequest.initializeMenu();
            SitemapRequest.getInstance().start();
            if( menu != null ) {
                ExceptionHandler.setUseToasts( true );
                return [ menu, new HomepageMenuDelegate() ];
            } else {
                return [ new LoadingView() ];
            }
        } catch( ex ) {
            return [ ErrorViewHandler.createOrUpdateErrorView( ex ) ];
        }
    }

    function getGlanceView() as [ GlanceView ] or [ GlanceView, GlanceViewDelegate ] or Null {
        _glanceView = new GlanceSitemapView();
        return [ _glanceView ];
    }


    (:release) function onAppUpdate() as Void {
        Storage.clearValues();
    }
    function onSettingsChanged() as Void {
        Logger.debug( "OHApp.onSettingsChanged" );
        Storage.clearValues();
    }

}

function getApp() as OHApp {
    return Application.getApp() as OHApp;
}