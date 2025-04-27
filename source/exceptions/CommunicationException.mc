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
        } else if ( _responseCode == -400 ) {
            return "Invalid response, maybe wrong sitemap name?";
        } else {
            return "Request failed: " + _responseCode;
        }
    }
}