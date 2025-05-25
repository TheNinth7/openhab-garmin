import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Application.Storage;
import Toybox.Application;
import Toybox.Timer;

/*
 * This class handles web requests for sitemap data and follows the Singleton pattern.
 *
 * Responsibilities:
 * - Constructs the URL for the sitemap request.
 * - Implements Communication.makeWebRequest:
 *     - start(): initiates the first web request.
 *     - After each response, the next request is scheduled based on the polling interval.
 *       If the polling interval is 0, the next request is triggered immediately.
 *     - stop(): halts all further web requests.
 *       If a request is already in progress, its response will be ignored after stop() is called.
 * - Implements onReceive() to process responses:
 *     - On success, stores the result as a SitemapHomepage in SitemapStore.
 *     - Depending on the current UI state:
 *         - If the menu structure doesn't exist (e.g., from LoadingView), it is created.
 *         - If the menu already exists, it is updated.
 *         - If currently in an error view and the response is valid, the error view is replaced with the menu structure.
 */
class SitemapRequest extends BaseRequest {
    
    // Defines the source value to be used for exception handling
    private static const SOURCE as CommunicationBaseException.Source = CommunicationBaseException.EX_SOURCE_SITEMAP;

    // After an error, the next request should not be sent before
    // this amount of time
    public static const SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL as Number = 1000;

    // After an error, the next request will be sent after
    // this amount of time, factoring in the configured interval
    // and the minimum defined above
    private static function getSitemapErrorPollingInterval() as Number {
        return         
            AppSettings.getPollingInterval() > SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL
            ? AppSettings.getPollingInterval()
            : SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL;
    }

    // Singleton instance and accessor
    private static var _instance as SitemapRequest?;
    public static function get() as SitemapRequest {
        if( _instance == null ) {
            _instance = new SitemapRequest();
        }
        return _instance as SitemapRequest;
    }

    // The assembled URL for the request
    private var _url as String;
    
    // Members for controlling the behavior when stopped.
    // if _isStopped is true, no further requests will be allowed
    private var _isStopped as Boolean = true;
    // _hasPendingRequest is true if we are inbetween a makeRequest()
    // and an onReceive
    private var _hasPendingRequest as Boolean = false;
    // If stop() is called and there is a pending request, this
    // is set to true to instrucht onReceive() to ignore the
    // next incoming response.
    private var _ignoreNextResponse as Boolean = false;

    // Members for controlling the web request loop
    private var _pollingInterval as Number;
    private var _timer as Timer.Timer = new Timer.Timer();

    // Store the memory usage before making the request, to
    // estimate the memory used by the received JSON
    // See `SitemapStore` for details.
    private var _memoryUsedBeforeRequest as Number = 0;

    // Constructor
    private function initialize() {
        // Initialize super class
        BaseRequest.initialize( Communications.HTTP_REQUEST_METHOD_GET );
        // Set response content type
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON );

        // Set the polling interval
        _pollingInterval = AppSettings.getPollingInterval();
        
        // Assemble the URL
        _url = AppSettings.getUrl() + "rest/sitemaps/" + AppSettings.getSitemap();
    }

    // Start and stop the repeated makeRequest
    public function start() as Void {
        if( _isStopped ) {
            _isStopped = false;
            makeRequest();
        }
    }
    // Stops the request loop
    // If there is a pending request, onReceive() is instructed to
    // ignore the next response
    public function stop() as Void {
        _isStopped = true;
        if( _hasPendingRequest ) {
            _ignoreNextResponse = true;
        }
    }

    // Makes the web request
    public function makeRequest() as Void {
        if( ! _isStopped ) {
            // Logger.debug( "BaseSitemapRequest: making request" );
            Communications.makeWebRequest( _url, null, getBaseOptions(), method( :onReceive ) );
            _memoryUsedBeforeRequest = System.getSystemStats().usedMemory;
            _hasPendingRequest = true;
        }
    }

    // Processes the response
    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        _hasPendingRequest = false;
        // Logger.debug( "BaseSitemapRequest.onReceive");

        // Taking the stored polling interval in a
        // local variable, since it may be adjusted
        // in case of error.
        var pollingInterval = _pollingInterval;

        // When stop() is called, and there is a pending request, then
        // _ignoreNextResponse is set true. onReceive() acts on this,
        // ignores the next response and resets the member
        if( _ignoreNextResponse ) {
            _ignoreNextResponse = false;
        } else {
            try {
                // Verify response code and response data
                // These functions of the super class throw
                // an exception if the code/data is not OK
                checkResponseCode( responseCode, SOURCE );
                
                /*
                Logger.debugMemory(
                    System.getSystemStats().usedMemory
                    - _memoryUsedBeforeRequest 
                );
                */
                
                // We hand over the JSON to the `SitemapStore`, for storage
                // and for creating the `SitemapHomepage`. data handed over
                // is checked via checkResponse, and we also approximate the
                // memory used (see `SitemapStore` for details)
                var sitemapHomepage = 
                    SitemapStore.updateSitemapFromJson( 
                        checkResponse( data, SOURCE ),
                        System.getSystemStats().usedMemory
                        - _memoryUsedBeforeRequest );
                
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
            } catch( ex ) {
                // Calling the handler for exceptions
                ExceptionHandler.handleException( ex );
                // If there is an error, the interval to the
                // next request will be adjusted to the constant
                // value defined at the beginning of this class
                pollingInterval = getSitemapErrorPollingInterval();
            }

            // Depending on polling interval the next request is
            // scheduled via timer or triggered immediately
            if( pollingInterval > 0 ) {
                // Logger.debug( "BaseSitemapRequest: starting timer for " + _pollingInterval + "ms" );
                _timer.start( method( :makeRequest ), pollingInterval, false );
            } else {
                makeRequest();
            }
        }
    }
}