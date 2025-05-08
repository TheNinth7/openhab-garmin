import Toybox.Lang;

/*
    Exception representing any errors when reading 
    the app settings
*/
(:glance)
class ConfigException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
