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
    
    // Indicates whether the state is fresh
    // If received via web request, it is always considered
    // fresh, if read from storage it depends on the data's age
    public var isStateFresh as Boolean;

    // Constructor
    protected function initialize( data as JsonObject, initStateFresh as Boolean ) {
        // Reading the id and label from the JSON element
        isStateFresh = initStateFresh;
        id = getString( data, ID, "Sitemap element: no " + ID + " found" );
        label = getString( data, LABEL, "Sitemap element: no " + LABEL + " found" );
    }

    // Returns a String from a given JsonObject, 
    // or an error message if the value is not present
    protected function getString( data as JsonObject, id as String, errorMessage as String ) as String {
       var value = data[id] as String?;
        if( value == null || value.equals( "" ) ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
    // Returns a Number from a given JsonObject, 
    // or defaults to the passed in def value if the value is not present
    protected function getNumber( data as JsonObject, id as String, def as Number ) as Number {
        var value = data[id] as Number?;
        return value == null ? def : value;
    }
    // Returns a Boolean from a given JsonObject, 
    // defaults to false if the value is not present
    protected function getBoolean( data as JsonObject, id as String ) as Boolean {
        var value = data[id] as Boolean?;
        return value == null ? false : value;
    }
    // Returns another JsonObject from a given JsonObject, 
    // or an error message if the value is not present
    protected function getObject( data as JsonObject, id as String, errorMessage as String ) as JsonObject {
        var value = data[id] as JsonObject?;
        if( value == null ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
    // Returns a JsonArray from a given JsonObject, 
    // or an error message if the value is not present
    protected function getArray( data as JsonObject, id as String, errorMessage as String ) as JsonArray {
        var value = data[id] as JsonArray?;
        if( value == null || value.size() == 0 ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }
}