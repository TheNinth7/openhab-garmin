import Toybox.Lang;

/*
 * Exception for any non-200 response codes from `Communications.makeWebRequest`.
 * Positive codes represent HTTP status codes (e.g., 404 for Not Found).
 * Negative codes represent Garmin SDK errors (e.g., –400 for unexpected response content type).
 */
(:glance)
class CommunicationException extends CommunicationBaseException {

    // The response code from Communications.makeWebRequest
    private var _responseCode as Number;
    public function getResponseCode() as Number {
        return _responseCode;
    }

    // Constructor
    public function initialize( code as Number, source as CommunicationBaseException.Source ) {
        CommunicationBaseException.initialize( source );
        _responseCode = code;
    }

    // Get the long error message
    public function getErrorMessage() as String or Null {
        var errorMsg;
        // For some errors we return specific messages,
        // for all others a generic one
        if ( _responseCode == -104 || _responseCode == -2 ) {
            return "No phone";
        } else if ( _responseCode == -400 ) {
            errorMsg = "Invalid response, check your app settings.";
        } else {
            errorMsg = "Request failed with code " + _responseCode;
        }
        return getSourceName() + ": " + errorMsg;
    }

    // Toast message
    public function getToastMessage() as String {
        var errorMsg;
        // For some errors we return specific toast messages,
        // for all others a generic one
        if ( _responseCode == -104 || _responseCode == -2 ) {
            return "No phone";
        } else if ( _responseCode == -400 ) {
            errorMsg = "INVRES";
        } else {
            errorMsg = _responseCode.toString();
        }
        return getSourceShortCode() + ":" + errorMsg;
    }

    // Most response codes are treated as non-fatal,
    // with a few exceptions
    public function isFatal() as Boolean {
        // return false; // activate this to use -1001 in simulator to test non-fatal errors
        return 
            ( _responseCode == -1001 ) 
            || ( _responseCode == 404 ); 
    }
}