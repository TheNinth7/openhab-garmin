import Toybox.Lang;
import Toybox.WatchUi;

class SitemapElement {
    function initialize() {
    }
    function getString( data as JsonObject, id as String, errorMessage as String ) as String {
       var value = data[id] as String?;
        if( value == null || value.equals( "" ) ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
    function getObject( data as JsonObject, id as String, errorMessage as String ) as JsonObject {
        var value = data[id] as JsonObject?;
        if( value == null ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
    function getArray( data as JsonObject, id as String, errorMessage as String ) as JsonArray {
        var value = data[id] as JsonArray?;
        if( value == null || value.size() == 0 ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
}