import Toybox.Lang;

(:glance)
class ConfigException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
