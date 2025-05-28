import Toybox.Lang;

/*
 * This file contains all classes representing asynchronous tasks used to
 * process incoming responses from `SitemapRequest`.
 *
 * The response is handled by the following tasks:
 *
 * 1) CreateSitemapTask:
 *     Triggered by `SitemapProcessor` with a JSON dictionary as input.
 *     It creates a `SitemapHomepage` and then schedules the next task.
 *     NOTE: Parsing the JSON dictionary is a time-consuming operation.
 *     Therefore, `SitemapHomepage` schedules its own asynchronous tasks
 *     to the *front of the queue*, ensuring they are executed before the
 *     next task.
 *
 * 2) UpdateMenuTask:
 *     Updates the menu structure.
 *     NOTE: This can be time-consuming, so BaseMenuPage.update() splits the
 *     update into smaller tasks, which are added to the **front** of the task queue.
 *
 * 3) RefreshUiTask:
 *     Refreshes the UI based on the current state:
 *       - If in a valid menu, refreshes the current screen.
 *       - If the menu structure is invalid or an error view is active, 
 *         navigates to the homepage menu.
 *       - If in the settings menu, does nothing.
 *
 * 4) MakeNextRequestTask:
 *     Initiates the next web request to update the sitemap.
 */

// Base class that provides the exception handling
class BaseSitemapProcessorTask {
    protected function initialize() {
    }
    public function handleException( ex as Exception ) as Void {
        SitemapRequest.get().handleException( ex );
    }
}

// The first task initalizes with the incoming JSON
// and a instantiates a SitemapHomepage to reepresent it
// This is a recursive process, and SitemapPage, the base
// class of SitemapHomepage, will create tasks on its own
// for the processing. These tasks are added to THE FRONT
// OF THE QUEUE, and therefore will be executed before 
// the next step is triggered, the UpdateUiTask.
class CreateSitemapTask extends BaseSitemapProcessorTask {

    private var _json as SitemapJsonIncoming;
    public function initialize( json as SitemapJsonIncoming ) {
        BaseSitemapProcessorTask.initialize();
        _json = json;
    }

    public function invoke() as Void {
        // Logger.debug( "CreateSitemapTask.invoke" );

        TaskQueue.get().add( 
            new UpdateMenuTask(
                SitemapStore.updateSitemapFromJson( 
                    _json,
                    true
                )
            )
        );
    }
}

// ... next step is to update the menu structure ...
class UpdateMenuTask extends BaseSitemapProcessorTask {

    // This tasks needs the SitemapHomepage representing the
    // newly incoming data as input
    private var _sitemapHomepage as SitemapHomepage;
    public function initialize( sitemapHomepage as SitemapHomepage ) {
        BaseSitemapProcessorTask.initialize();
        _sitemapHomepage = sitemapHomepage;
    }

    public function invoke() as Void {
        // Logger.debug( "UpdateMenuTask.invoke" );
        if( ! HomepageMenu.exists() ) {
            throw new GeneralException( "HomepageMenu does not exist" );
        }
        
        HomepageMenu.get().update( _sitemapHomepage );

        TaskQueue.get().add( new RefreshUiTask() );
    }
}

// Refresh the UI based on the current context and menu validity:
//
// - If currently in a menu and the menu structure remains valid (as per task input),
//   refresh the current screen.
// - If the menu structure is no longer valid, navigate to the root (homepage) menu.
// - If currently in an error view, navigate to the homepage menu.
// - If currently in the settings menu, do nothing.
class RefreshUiTask extends BaseSitemapProcessorTask {

    public function initialize() {
        BaseSitemapProcessorTask.initialize();
    }

    public function invoke() as Void {
        
        // Logger.debug( "RefreshUiTask.invoke" );

        if( ! HomepageMenu.exists() ) {
            throw new GeneralException( "HomepageMenu does not exist" );
        }

        var homepage = HomepageMenu.get();

        // If we are in the settings menu, we do nothing
        if( ! SettingsMenuHandler.isShowingSettings() ) {
            // If the structure is not valid anymore, we reset the view
            // to the homepage, but only if we are not in the error view
            if(    ! homepage.structureRemainsValid() 
                && ! ErrorView.isShowingErrorView() 
                && ! ( WatchUi.getCurrentView()[0] instanceof HomepageMenu ) ) {
                // If update returns false, the menu structure has changed
                // and we therefore replace the current view stack with
                // the homepage. If the current view already is the homepage,
                // then of course this is not necessary and we skip to the
                // WatchUi.requestUpdate() further below.
                // Logger.debug( "SitemapRequest.onReceive: resetting to homepage" );
                ViewHandler.popToBottomAndSwitch( homepage, HomepageMenuDelegate.get() );
            } else if( ErrorView.isShowingErrorView() ) {
                // If currently there is an error view, we replace it
                // by the homepage
                ErrorView.replace( homepage, HomepageMenuDelegate.get() );
            } else {
                // If the structure is still valid and no error is shown,
                // then we update the screen, showing the changes in the
                // currently displayed menu
                // Logger.debug( "SitemapRequest.onReceive: requesting UI update" );
                WatchUi.requestUpdate();
            }
        }
        TaskQueue.get().add( new TriggerNextRequestTask() );
    }
}

// ... and finally, we trigger the next request
class TriggerNextRequestTask extends BaseSitemapProcessorTask {
    public function initialize() {
        BaseSitemapProcessorTask.initialize();
    }
    public function invoke() as Void {
        // Logger.debug( "TriggerNextRequestTask.invoke" );
        SitemapRequest.get().triggerNextRequest();
    }
}
