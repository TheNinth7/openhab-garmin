import Toybox.Lang;

class CommunicationException extends Exception {
    private var _responseCode as Number;
    private var _source as ExceptionSource;

    public function initialize( code as Number, source as ExceptionSource ) {
        Exception.initialize();
        _responseCode = code;
        _source = source;
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
        return ExceptionHandler.getSourceName( _source ) + ": " + errorMsg;
    }

    public function getToastMessage() as String {
        if ( _responseCode == -104 ) {
            return "No phone";
        } else {
            return ExceptionHandler.getSourceShortCode( _source ) + _responseCode.toString();
        }
    }
}