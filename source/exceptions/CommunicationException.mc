import Toybox.Lang;

(:glance)
class CommunicationException extends CommunicationBaseException {

    private var _responseCode as Number;

    public function initialize( code as Number, source as CommunicationBaseException.Source ) {
        CommunicationBaseException.initialize( source );
        _responseCode = code;
    }

    public function getErrorMessage() as String or Null {
        var errorMsg;
        if ( _responseCode == -104 ) {
            return "No phone";
        } else if ( _responseCode == -400 ) {
            errorMsg = "Invalid response, check your app settings.";
        } else {
            errorMsg = "Request failed with code " + _responseCode;
        }
        return getSourceName() + ": " + errorMsg;
    }

    public function getToastMessage() as String {
        if ( _responseCode == -104 ) {
            return "No phone";
        } else {
            return getSourceShortCode() + _responseCode.toString();
        }
    }

    public function isFatal() as Boolean {
        return 
            ( _responseCode == -1001 ) 
            || ( _responseCode == 404 ); 
    }

}