import Toybox.Lang;

(:glance)
class CommunicationException extends Exception {
    enum Source {
        EX_SOURCE_SITEMAP,
        EX_SOURCE_COMMAND
    }

    private var _responseCode as Number;
    private var _source as Source;

    private const SOURCE_NAMES = [ "Sitemap", "Command" ];
    private const SOURCE_SHORTCODE = [ "S", "C" ];

    public function initialize( code as Number, source as Source ) {
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
        return SOURCE_NAMES[_source] + ": " + errorMsg;
    }

    public function getToastMessage() as String {
        if ( _responseCode == -104 ) {
            return "No phone";
        } else {
            return SOURCE_SHORTCODE[_source] + _responseCode.toString();
        }
    }
}