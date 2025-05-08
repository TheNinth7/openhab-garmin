import Toybox.Lang;

/*
    Any issues occuring when reading the JSON dictionary
    received via the web request or from storage into
    the structure defined in source/json
*/
(:glance)
class JsonParsingException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
