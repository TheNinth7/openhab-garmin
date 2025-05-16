import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Base class for all sitemap elements.
 */

// Types representing dictionary and array objects used for JSON structures 
// sent to or received from web requests.
typedef JsonObject as Dictionary<String,Object?>;
typedef JsonArray as Array<JsonObject>;

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
    //! Returns a number from a JsonObject, or its passed in default value
    //! @param data - the JsonObject
    //! @param id - the name of the number in the JsonObject
    //! @param def - the default value that will be returned if the number is not present in the JsonObject
    protected function getNumber( data as JsonObject, id as String, def as Number ) as Number {
        var value = data[id] as Number?;
        return value == null ? def : value;
    }
    protected function getBoolean( data as JsonObject, id as String ) as Boolean {
        var value = data[id] as Boolean?;
        return value == null ? false : value;
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