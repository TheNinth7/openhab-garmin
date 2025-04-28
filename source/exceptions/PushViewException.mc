import Toybox.Lang;

class PushViewException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
