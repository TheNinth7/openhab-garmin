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
class SitemapBaseRequest extends BaseRequest {
    
    // Defines the source value to be used for exception handling
    private static const SOURCE as CommunicationBaseException.Source = CommunicationBaseException.EX_SOURCE_SITEMAP;

    // The assembled URL for the request
    private var _url as String;
    
    // Members for controlling the web request loop
    private var _isStopped as Boolean = true;
    private var _pollingInterval as Number;
    private var _timer as Timer.Timer = new Timer.Timer();

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
    public function stop() as Void {
        _isStopped = true;
    }

    // Makes the web request
    public function makeRequest() as Void {
        Logger.debug( "BaseSitemapRequest.makeRequest");
        if( ! _isStopped ) {
            Communications.makeWebRequest( _url, null, getBaseOptions(), method( :onReceive ) );
        }
    }

    // Processes the response
    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        Logger.debug( "BaseSitemapRequest.onReceive");
        // If the request was stopped, we ignore any responses
        // coming in, in case stop() was called between makeRequest()
        // and onReceive()
        if( ! _isStopped ) {
            try {
                // Verify response code and response data
                // These functions of the super class throw
                // an exception if the code/data is not OK
                checkResponseCode( responseCode, SOURCE );
                var json = checkResponse( data, SOURCE );
                
                // The JSON is stored in the SitemapStore
                SitemapStore.updateJson( json );
                var sitemapHomepage = new SitemapHomepage( json );
                // Also the label is stored (for use by glance)
                SitemapStore.updateLabel( sitemapHomepage.label );
                
                // Calling the event handlers for updated
                // sitemap and successful completion of
                // processing
                onSitemapUpdate( sitemapHomepage );
                onSuccess();
            } catch( ex ) {
                // Calling the event handler for exceptions
                onException( ex );
            }

            // Depending on polling interval the next request is
            // scheduled via timer or triggered immediately
            if( _pollingInterval > 0 ) {
                Logger.debug( "BaseSitemapRequest: starting timer for " + _pollingInterval + "ms" );
                _timer.start( method( :makeRequest ), _pollingInterval, false );
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
    // onSuccess() by default resets the error count and
    // can be overriden for additional functionality
    public function onSuccess() as Void {
        Logger.debug( "BaseSitemapRequest.onSuccess");
        SitemapErrorCountStore.reset();
    }

}