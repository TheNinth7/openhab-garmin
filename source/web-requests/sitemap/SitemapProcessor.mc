import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

/*
 * The SitemapProcessor handles incoming JSON data from the SitemapRequest.
 * 
 * The main entry point is the static process() function. If no HomepageMenu
 * exists yet (i.e., when the UI is still in the LoadingView), the menu is created
 * and displayed via switchToHomepage(). If the HomepageMenu already exists,
 * it is updated using updateHomepage().
 * 
 * Both functions divide their work into small tasks that are processed through
 * the AsyncTaskQueue. This approach processes recursive data structures iteratively,
 * avoiding stack overflow issues and mitigating errors from lengthy consecutive
 * code execution (e.g., "Watchdog Tripped Error - Code Executed Too Long"). It also
 * helps keep the UI responsive.
 */
class SitemapProcessor {

    // Main entry point for all JSONs incoming via web requests
    public static function process( incomingJson as SitemapJsonIncoming ) as Void {
        // Logger.debug( "SitemapProcessor: start processing incoming JSON" );
        if( ! HomepageMenu.exists() ) {
            // No menu exists yet, so we process the JSON and transition 
            // from the LoadingView to the menu.
            // This can also happen after an out-of-memory exception,
            // where the menu was cleared — in that case, we switch
            // from the ErrorView to the new menu.
            switchToHomepage( incomingJson );
        } else {
            // There is already a menu, so we update it,
            // asynchronously to not block the UI
            updateHomepage( incomingJson );
        }
    }

    // Synchronously create the HomepageMenu and switch to it
    private static function switchToHomepage( incomingJson as SitemapJsonIncoming ) as Void {
        // Logger.debug( "SitemapProcessor.switchToHomepage" );
        var taskQueue = AsyncTaskQueue.get();
        
        // Switching to the homepage occurs from non-interactive
        // views (error/loading) and thus speed in processing
        // is more important than responsiveness
        taskQueue.prioritizeSpeed();
        
        taskQueue.add(
            new StartInitMenuTask(
                incomingJson
            )
        );
    }

    // Update an existing HomepageMenu
    private static function updateHomepage( incomingJson as SitemapJsonIncoming ) as Void {
        // Logger.debug( "SitemapProcessor.updateHomepage" );

        var taskQueue = AsyncTaskQueue.get();
        
        // When updating, speed is not as important as
        // responsiveness of the UI
        taskQueue.prioritizeResponsiveness();

        // Verify that the task queue is empty
        // It should always be at this point, because a new 
        // web request is only initiated when processing of the
        // previous one has been completed
        if( ! taskQueue.isEmpty() ) {
            throw new GeneralException( "SitemapProcessor encountered non-empty task queue" );
        }
        
        taskQueue.add( new StartUpdateMenuTask( incomingJson ) );
    }
}
    