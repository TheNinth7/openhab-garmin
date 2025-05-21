import Toybox.Lang;
import Toybox.PersistedContent;
import Toybox.Timer;

/*
    This is the sitemap request implementation for the widget
    
    It is implemented as a Singleton, as there is only one sitemap
    active at a time. This allows access from other classes,
    without carrying a reference to the instance around.

    The class instantiates the root menu (homepage menu) representing
    the sitemap on the UI, and updates it with every new incoming response.
*/
class WidgetSitemapRequest extends BaseSitemapRequest {

    // Singleton instance and accessor
    private static var _instance as WidgetSitemapRequest?;
    public static function get() as WidgetSitemapRequest {
        if( _instance == null ) {
            _instance = new WidgetSitemapRequest();
        }
        return _instance as WidgetSitemapRequest;
    }

    // This function is called on startup by OHApp, and 
    // if available initializes the menu from sitemap data
    // in storage
    public static function initializeMenu() as HomepageMenu? {
        var homepageMenu = null;
        try {
            var sitemapHomepage = SitemapStore.getHomepage();
            if( sitemapHomepage != null ) {
                homepageMenu = HomepageMenu.create( sitemapHomepage );
            }
        } catch( ex ) {
            Logger.debugException( ex );
        }
        return homepageMenu;
    }

    // Constructor
    private function initialize() {
        // There is no minimum polling interval for the widget request,
        // therefore we pass 0 into the super class constructor.
        BaseSitemapRequest.initialize( null );
    }

    // Event handler for valid responses
    // If there is any error coming from the request or the response was 
    // invalid, the onException() event handler is called instead
    public function onSitemapUpdate( sitemapHomepage as SitemapHomepage ) as Void {
        // Logger.debug( "SitemapRequest.onSitemapUpdate");
        if( ! HomepageMenu.exists() ) {
            // There is no menu yet, so we need to switch
            // from the LoadingView to the menu
            WatchUi.switchToView( 
                HomepageMenu.create( sitemapHomepage ), 
                HomepageMenuDelegate.get(), 
                WatchUi.SLIDE_BLINK );
        } else {
            // There is already a menu, so we update it

            var homepage = HomepageMenu.get();

            // the update function returns whether the structure of the menu
            // remained unchanged, i.e. if containers have been added or removed
            var structureRemainsValid = homepage.update( sitemapHomepage );
            
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
        }
    }

    // Any exceptions from the request/response will be handled
    // by this function and passed directly to the ExceptionHandler
    public function onException( ex as Exception ) as Void {
        ExceptionHandler.handleException( ex );
    }
}