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
 * These tasks are managed by the TaskQueue, allowing gaps between them
 * for user input to be processed. This avoids noticeable lag or UI
 * unresponsiveness when handling large sitemaps.
 *
 * For this, an instance of SitemapProcessor is created, and the instance
 * functions createSitemap() and updateUi() are executed via tasks defined in
 * AsyncSitemapTasks.mc, along with SitemapRequest.triggerNextRequest().
 */
class SitemapProcessor {

    // STATIC MEMBERS

    // Main entry point for all JSONs incoming via web requests
    public static function process( incomingJson as IncomingJson ) as Void {
        Logger.debug( "SitemapProcessor: start" );
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
    private static function switchToHomepage( incomingJson as IncomingJson ) as Void {
        Logger.debug( "SitemapProcessor.switchToHomepage" );
        WatchUi.switchToView( 
            HomepageMenu.create( 
                SitemapStore.updateSitemapFromJson( incomingJson )
            ), 
            HomepageMenuDelegate.get(), 
            WatchUi.SLIDE_BLINK 
        );
        SitemapRequest.get().triggerNextRequest();
    }

    // Update an existing HomepageMenu
    private static function updateHomepageAsync( incomingJson as IncomingJson ) as Void {
        Logger.debug( "SitemapProcessor.updateHomepageAsync" );

        // Create a processor instance
        var sitemapProcessor = new SitemapProcessor( incomingJson );
        
        // And add the three tasks to the task queue
        var taskQueue = TaskQueue.get();
        // Verify that the task queue is empty
        // It should always be at this point, because a new 
        // web request is only initiated when processing of the
        // previous one has been completed
        if( ! taskQueue.isEmpty() ) {
            throw new GeneralException( "SitemapProcessor encountered non-empty task queue" );
        }
        taskQueue.add( new CreateSitemapTask( sitemapProcessor ) );
        taskQueue.add( new UpdateUiTask( sitemapProcessor ) );
        taskQueue.add( new TriggerNextRequestTask( sitemapProcessor ) );
    }

    // PRIVATE MEMBERS

    // The private instance retains the data that needs
    // to be passed on from on task to the next
    private var _json as IncomingJson?;
    private var _sitemapHomepage as SitemapHomepage?;

    // We initialize with the incoming JSON ...
    private function initialize( incomingJson as IncomingJson ) {
        _json = incomingJson;
    }

    // ... then create the sitemap from it ...
    // Pass the JSON on to the `SitemapStore`, which
    // returns the SitemapHomepage, the result of the parsing
    public function createSitemap() as Void {
        Logger.debug( "SitemapProcessor: async create sitemap" );
        if( _json == null ) {
            throw new GeneralException( "JSON does not exist" );
        }
        _sitemapHomepage = 
            SitemapStore.updateSitemapFromJson( _json as IncomingJson );
        _json = null;
    }

    // ... next step is to update the UI ...
    // This function updates the menu structure and if we are
    // currently in an ErrorView switch back to the menu
    public function updateUi() as Void {
        Logger.debug( "SitemapProcessor: async update UI" );

        if( _sitemapHomepage == null ) {
            throw new GeneralException( "SitemapHomepage does not exist" );
        }
        if( ! HomepageMenu.exists() ) {
            throw new GeneralException( "HomepageMenu does not exist" );
        }

        var homepage = HomepageMenu.get();

        // the update function returns whether the structure of the menu
        // remained unchanged, i.e. if containers have been added or removed
        var structureRemainsValid = 
            homepage.update( _sitemapHomepage as SitemapHomepage );
        
        // If we are in the settings menu, we do nothing
        if( ! SettingsMenuHandler.isShowingSettings() ) {
            // If the structure is not valid anymore, we reset the view
            // to the homepage, but only if we are not in the error view
            if(    ! structureRemainsValid 
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
        _sitemapHomepage = null;
    }
}
