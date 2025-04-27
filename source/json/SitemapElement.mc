import Toybox.Lang;
import Toybox.WatchUi;

class SitemapElement {

    public var ID as String = "widgetId";
    public var LABEL as String = "label";

    public var id as Object;
    public var label as String;

    protected function initialize( data as JsonObject ) {
        id = getString( data, ID, "Sitemap element: no " + ID + " found" );
        label = getString( data, LABEL, "Sitemap element: no " + LABEL + " found" );
    }

    protected function getString( data as JsonObject, id as String, errorMessage as String ) as String {
       var value = data[id] as String?;
        if( value == null || value.equals( "" ) ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
    protected function getObject( data as JsonObject, id as String, errorMessage as String ) as JsonObject {
        var value = data[id] as JsonObject?;
        if( value == null ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
    protected function getArray( data as JsonObject, id as String, errorMessage as String ) as JsonArray {
        var value = data[id] as JsonArray?;
        if( value == null || value.size() == 0 ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
}