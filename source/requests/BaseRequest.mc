import Toybox.Lang;
import Toybox.Communications;

class BaseRequest {
    protected var _options as WebRequestOptions;

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
    public function checkResponseCode( responseCode as Number ) as Void {
        if( responseCode != 200 ) {
            throw new CommunicationException( responseCode );
        }
    }
}