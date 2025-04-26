import Toybox.Lang;

class CommunicationException extends Exception {
    private var _responseCode as Number;
    function initialize( code as Number ) {
        Exception.initialize();
        _responseCode = code;
    }

    function getErrorMessage() as String or Null {
        if ( _responseCode == -104 ) {
            return "No phone";
        } else {
            return "Request failed: " + _responseCode;
        }
    }
}