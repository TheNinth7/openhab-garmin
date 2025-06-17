import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

/*
 * The SitemapProcessor is responsible for handling incoming JSON data
 * from the SitemapRequest.
 *
 * The static process() function is the main entry point. If no HomepageMenu
 * exists yet (i.e., we are in the LoadingView), the menu is created and 
 * displayed synchronously via the static switchToHomepage().
 *
 * If the HomepageMenu already exists, it is updated asynchronously using 
 * updateHomepageAsync(). Since updates can take time and CIQ apps are 
 * single-threaded, the update is broken into multiple tasks.
 * These tasks are managed by the AsyncTaskQueue, allowing gaps between them
 * for user input to be processed. This avoids noticeable lag or UI
 * unresponsiveness when handling large sitemaps.
 *
 * For this, an instance of CreateSitemapTask is created, which subsequently
 * triggers UpdateUiTask and MakeNextRequestTask.
 */
class SitemapProcessor {

    // Main entry point for all JSONs incoming via web requests
    public static function process( incomingJson as SitemapJsonIncoming ) as Void {
        // Logger.debug( "SitemapProcessor: start processing incoming JSON" );
        if( ! HomepageMenu.exists() ) {
            // There is no menu yet, so we process the JSON
            // synchronously and switch from the LoadingView 
            //to the menu
            switchToHomepage( incomingJson );
        } else {
            // There is already a menu, so we update it,
            // asynchronously to not block the UI
            updateHomepageAsync( incomingJson );
        }
    }

    // Synchronously create the HomepageMenu and switch to it
    private static function switchToHomepage( incomingJson as SitemapJsonIncoming ) as Void {
        // Logger.debug( "SitemapProcessor.switchToHomepage" );
        WatchUi.switchToView( 
            HomepageMenu.create( 
                SitemapStore.updateSitemapFromJson( 
                    incomingJson,
                    false
                )
            ), 
            HomepageMenuDelegate.get(), 
            WatchUi.SLIDE_BLINK 
        );
        SitemapRequest.get().triggerNextRequest();
    }

    // Update an existing HomepageMenu
    private static function updateHomepageAsync( incomingJson as SitemapJsonIncoming ) as Void {
        // Logger.debug( "SitemapProcessor.updateHomepageAsync" );

        var taskQueue = AsyncTaskQueue.get();
        // Verify that the task queue is empty
        // It should always be at this point, because a new 
        // web request is only initiated when processing of the
        // previous one has been completed
        if( ! taskQueue.isEmpty() ) {
            throw new GeneralException( "SitemapProcessor encountered non-empty task queue" );
        }
        taskQueue.add( new CreateSitemapTask( incomingJson ) );
    }
}
    