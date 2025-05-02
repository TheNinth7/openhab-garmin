import Toybox.Lang;
import Toybox.Communications;

(:glance)
class BaseRequest {
    private var _options as WebRequestOptions;

    protected function setOption( option as Symbol, value as Object ) as Void {
        _options[option] = value;
    }
    protected function getOptions() as WebRequestOptions {
        return _options;
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

    protected function checkResponse( data as Object?, source as CommunicationBaseException.Source ) as Void {
        if( ! ( data instanceof Dictionary ) ) {
            throw new UnexpectedResponseException( data, source );
        }
    }

}