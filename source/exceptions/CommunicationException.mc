import Toybox.Lang;

class CommunicationException extends Exception {
    private var _responseCode as Number;
    private var _source as ExceptionSource;

    function initialize( code as Number, source as ExceptionSource ) {
        Exception.initialize();
        _responseCode = code;
        _source = source;
    }

    function getErrorMessage() as String or Null {
        if ( _responseCode == -104 ) {
            return "No phone";
        } else if ( _responseCode == -400 ) {
            return "Invalid response, check your app settings.";
        } else {
            return "Request failed with code " + _responseCode;
        }
    }

    function getSource() as String {
        return ExceptionHandler.getSourceName( _source );
    }

    function getToastMessage() as String {
        if ( _responseCode == -104 ) {
            return "No phone";
        } else if ( _responseCode == -400 ) {
            return "Invalid response";
        } else {
            return "Error " + _responseCode;
        }
    }
}