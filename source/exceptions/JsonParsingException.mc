import Toybox.Lang;

(:glance)
class JsonParsingException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
