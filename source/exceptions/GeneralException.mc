import Toybox.Lang;

class GeneralException extends Exception {
    private var _msg as String;
    function initialize( msg as String ) {
        Exception.initialize();
        _msg = msg;
    }

    function getErrorMessage() as String or Null {
        return _msg;
    }
}