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
        if ( _responseCode == -104 || _responseCode == -2 ) {
            return "No phone";
        } else if ( _responseCode == -400 ) {
            errorMsg = "Invalid response, check your app settings.";
        } else {
            errorMsg = "Request failed with code " + _responseCode;
        }
        return getSourceName() + ": " + errorMsg;
    }

    public function getToastMessage() as String {
        var errorMsg;
        if ( _responseCode == -104 || _responseCode == -2 ) {
            return "No phone";
        } else if ( _responseCode == -400 ) {
            errorMsg = "INVRES";
        } else {
            errorMsg = _responseCode.toString();
        }
        return getSourceShortCode() + ":" + errorMsg;
    }

    public function isFatal() as Boolean {
        // return false; // activate this to use -1001 in simulator to test non-fatal errors
        return 
            ( _responseCode == -1001 ) 
            || ( _responseCode == 404 ); 
    }
}