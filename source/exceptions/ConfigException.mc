import Toybox.Lang;

class ConfigException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
