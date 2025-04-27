import Toybox.Lang;

class JsonParsingException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
