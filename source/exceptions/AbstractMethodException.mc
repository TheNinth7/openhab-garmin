import Toybox.Lang;

class AbstractMethodException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
