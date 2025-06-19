import Toybox.Lang;

/*
 * This file contains all classes representing asynchronous tasks used to
 * create a new menu structure from an incoming response from `SitemapRequest`.
 *
 * The response is handled by the following tasks:
 *
 * 1) StartUpdateMenuTask:
 *     Triggered by `SitemapProcessor` with a JSON dictionary as input.
 *     It creates a `SitemapHomepage` and then schedules the next task.
 *     NOTE: Parsing the JSON dictionary is a time-consuming operation.
 *     Therefore, `SitemapHomepage` schedules its own asynchronous tasks
 *     to the *front of the queue*, ensuring they are executed before the
 *     next task.
 *
 * 2) UpdateMenuTask:
 *     Updates the menu structure.
 *     NOTE: This can be time-consuming, so BasePageMenu.update() splits the
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
class StartInitMenuTask extends BaseSitemapProcessorTask {
    private var _incomingJson as SitemapJsonIncoming;

    public function initialize( incomingJson as SitemapJsonIncoming ) {
        BaseSitemapProcessorTask.initialize();
        _incomingJson = incomingJson;
    }
    
    public function invoke() as Void {
        Logger.debug( "StartInitMenuTask.invoke" );
        AsyncTaskQueue.get().add( 
            new CreateHomepageMenuTask(
                SitemapStore.updateSitemapFromJson( _incomingJson )
            )
        );
    }
}

class CreateHomepageMenuTask extends BaseSitemapProcessorTask {
    private var _sitemapHomepage as SitemapHomepage;

    public function initialize( sitemapHomepage as SitemapHomepage ) {
        BaseSitemapProcessorTask.initialize();
        _sitemapHomepage = sitemapHomepage;
    }
    
    public function invoke() as Void {
        Logger.debug( "CreateHomepageMenuTask.invoke" );
        AsyncTaskQueue.get().add(
            new SwitchToHomepageMenuTask(
                HomepageMenu.create( 
                    _sitemapHomepage,
                    true 
                )
            )
        );
    }
}

class SwitchToHomepageMenuTask extends BaseSitemapProcessorTask {
    private var _homepageMenu as HomepageMenu;

    public function initialize( homepageMenu as HomepageMenu ) {
        BaseSitemapProcessorTask.initialize();
        _homepageMenu = homepageMenu;
    }
    
    public function invoke() as Void {
        Logger.debug( "SwitchToHomepageMenuTask.invoke" );
        WatchUi.switchToView( 
            _homepageMenu, 
            HomepageMenuDelegate.get(), 
            WatchUi.SLIDE_BLINK 
        );
        SitemapRequest.get().triggerNextRequest();
    }
}