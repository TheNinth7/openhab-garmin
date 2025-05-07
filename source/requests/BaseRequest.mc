import Toybox.Lang;
import Toybox.Communications;

(:glance)
class BaseRequest {
    private var _options as WebRequestOptions;

    protected function setOption( option as Symbol, value as Object ) as Void {
        _options[option] = value;
    }
    protected function getBaseOptions() as WebRequestOptions {
        return _options;
    }
    protected function setHeader( name as String, value as String or Communications.HttpRequestContentType ) as Void {
        if( _options[:headers] == null ) {
            _options[:headers] = { name => value };
        } else {
            var options = _options[:headers] as Dictionary;
            options[name] = value;
        }
    }

    public function initialize() {
        _options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET
        };

        if( AppSettings.needsBasicAuth() ) {
            _options[:headers] = { 
                "Authorization" => "Basic " + StringUtil.encodeBase64( Lang.format( "$1$:$2$", [AppSettings.getUser(), AppSettings.getPassword() ] ) )
            };
        }
    }

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