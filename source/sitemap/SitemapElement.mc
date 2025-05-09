import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Base class for all sitemap elements.
 */
(:glance)
class SitemapElement {

    // Default field names for id and label
    // The homepage uses different fields for this by
    // overriding these variables
    public var ID as String = "widgetId";
    public var LABEL as String = "label";

    // The id and label of this instance
    public var id as Object;
    public var label as String;

    // Constructor
    protected function initialize( data as JsonObject ) {
        // Reading the id and label from the JSON element
        id = getString( data, ID, "Sitemap element: no " + ID + " found" );
        label = getString( data, LABEL, "Sitemap element: no " + LABEL + " found" );
    }

    // Helper functions for reading an element from the JSON
    // and throwing an error if the value is not present
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