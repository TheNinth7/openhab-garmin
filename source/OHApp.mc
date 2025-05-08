import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

(:glance)
class OHApp extends Application.AppBase {

    private static var _glanceView as GlanceSitemapView?;
    public static function isGlance() as Boolean {
        return _glanceView != null;
    }

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
            // First we initialize the menu from storage
            var menu = SitemapRequest.initializeMenu();
            var hasMenu = menu != null;

            // Then we start the sitemap request
            SitemapRequest.getInstance().start();
            
            // Starting the sitemap request may return an immediate error, which
            // SitemapRequest.onReceive reports to the ExceptionHandler via
            // handleException, and the ExceptionHandler stores it
            // consumeException then acts on the exception, and based if toasts
            // shall be used displays a toast for non-fatal errors, and in all
            // other cases returns an errorView for display.
            var errorView = ExceptionHandler.consumeStartupException( hasMenu );

            if( errorView != null ) {
                // If there is an error view, display it
                return [errorView];
            } else if( hasMenu ) {
                // If there is HomepageMenu, display it
                return [ menu as View, HomepageMenuDelegate.get() ];
            } else {
                // Otherwise show the loading view
                return [ new LoadingView() ];
            }
        } catch( ex ) {
            // Any exceptions occuring in this function are 
            // also displayed as error view
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