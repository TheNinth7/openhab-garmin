import Toybox.Lang;

/*
    Base exceptions for all others, and used for
    any exceptions that do not fit into any of the
    more specific exceptions
*/
(:glance)
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