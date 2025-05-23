import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.Application.Storage;
import Toybox.Application;
import Toybox.Timer;

/*
    The base class of all sitemap web requests.
    There are two derived classes, one each for doing the
    sitemap request in the glance and in the widget.
    This class:
    - assembles the URL for the request
    - implements the Communication.makeWebRequest
      - start() starts the first web request
      - after every response received, the next web request is scheduled
        based on polling interval or executed immediately if polling 
        interval is 0.
      - stop() stops any further web requests from being executed.
        if there is web request already underway, its response will NOT
        be processed after stop() has been called.
    - implements the onReceive() for processing the response. If successful,
      onReceive() stores the result as SitemapHomepage in the SitemapStore
    - provides three event handler functions that are called when a response 
      is received
      - onSitemapUpdate() for processing the response
        HAS to be implemented by derived class
      - onException() for processing any errors
        HAS to be implemented by derived class
      - onSuccess() final function called if response has been processed
        without errors. CAN be overriden by derived class
*/    
(:glance)
class BaseSitemapRequest extends BaseRequest {
    
    // Defines the source value to be used for exception handling
    private static const SOURCE as CommunicationBaseException.Source = CommunicationBaseException.EX_SOURCE_SITEMAP;

    // After an error, the next request should not be sent before
    // this amount of time
    public static const SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL as Number = 1000;

    // After an error, the next request will be sent after
    // this amount of time, factoring in the configured interval
    // and the minimum defined above
    public static function getSitemapErrorPollingInterval() as Number {
        return         
            AppSettings.getPollingInterval() > SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL
            ? AppSettings.getPollingInterval()
            : SITEMAP_ERROR_MINIMUM_POLLING_INTERVAL;
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
    protected function initialize( minimumPollingInterval as Number? ) {
        // Initialize super class
        BaseRequest.initialize( Communications.HTTP_REQUEST_METHOD_GET );
        // Set response content type
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON );

        // Set the polling interval
        _pollingInterval = AppSettings.getPollingInterval();
        if( minimumPollingInterval != null && _pollingInterval < minimumPollingInterval ) {
            _pollingInterval = minimumPollingInterval;
        }
        
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
                
                // Calling the event handlers for updated
                // sitemap and successful completion of
                // processing
                onSitemapUpdate( sitemapHomepage );
                onSuccess();
            } catch( ex ) {
                // Calling the event handler for exceptions
                onException( ex );
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

    // Event handlers
    // onSitemapUpdate() and onException() HAVE to be implemented by derived classes
    protected function onSitemapUpdate( sitemapHomepage as SitemapHomepage ) as Void {
        throw new AbstractMethodException( "BaseSitemapRequest.onSitemapUpdate" );
    }
    protected function onException( ex as Exception ) as Void {
        throw new AbstractMethodException( "BaseSitemapRequest.onException" );
    }
    // onSuccess() can be overriden for additional functionality
    public function onSuccess() as Void {
    }
}