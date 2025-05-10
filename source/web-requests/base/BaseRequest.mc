import Toybox.Lang;
import Toybox.Communications;

/*
    Base class for all web requests
    This class 
    - holds the options for the request
    - provides accessors to the options
    - applies basic authentication if set in the settings
    - provides functions for processing response code and response data
*/

// Options for the BaseRequest, mirroring (most) options of `Communications.makeWebRequest`
typedef WebRequestOptions as { 
    :method as Communications.HttpRequestMethod, 
    :headers as Lang.Dictionary, 
    :responseType as Communications.HttpResponseContentType, 
    :context as Lang.Object or Null, 
    :maxBandwidth as Lang.Number 
};

(:glance)
class BaseRequest {
    
    // The options to be passed in Communications.makeWebRequest
    private var _options as WebRequestOptions;
    protected function setOption( option as Symbol, value as Object ) as Void {
        _options[option] = value;
    }
    protected function getBaseOptions() as WebRequestOptions {
        return _options;
    }
    // Set HTTP header fields
    // The HTTP header is part of the optiosn
    protected function setHeader( name as String, value as String or Communications.HttpRequestContentType ) as Void {
        if( _options[:headers] == null ) {
            _options[:headers] = { name => value };
        } else {
            var options = _options[:headers] as Dictionary;
            options[name] = value;
        }
    }

    // Adds the HTTP request method and
    // if applicable basic authentication
    public function initialize( method as Communications.HttpRequestMethod ) {
        _options = {
            :method => method
        };

        if( AppSettings.needsBasicAuth() ) {
            _options[:headers] = { 
                "Authorization" => "Basic " + StringUtil.encodeBase64( Lang.format( "$1$:$2$", [AppSettings.getUser(), AppSettings.getPassword() ] ) )
            };
        }
    }

    // The response itself is processed by the onReceive functions
    // of the derived classes. They can make use of the following
    // two functions for checking response code and response data
    protected function checkResponseCode( responseCode as Number, source as CommunicationBaseException.Source ) as Void {
        if( responseCode != 200 ) {
            throw new CommunicationException( responseCode, source );
        }
    }
   protected function checkResponse( data as Object?, source as CommunicationBaseException.Source ) as JsonObject {
        if( ! ( data instanceof Dictionary ) ) {
            throw new UnexpectedResponseException( data, source );
        }
        return data as JsonObject;
    }
}