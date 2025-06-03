import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * The `JsonAdapter` wraps a `JsonObject` and provides functions
 * to access data within it.
 *
 * It is a recursive structure that also provides access to nested
 * `JsonAdapter` instances, as well as arrays of such objects.
 *
 * For many types, the class offers two kinds of accessors:
 * - One for mandatory fields, such as `getString()`, which takes an
 *   error message and throws an exception if the field is missing.
 * - One for optional fields, such as `getOptionalString()`, which
 *   returns null if the field is not present.
 */
typedef JsonAdapterArray as Array<JsonAdapter>;

class JsonAdapter {

    private var _jsonObject as JsonObject;

    // Constructor
    public function initialize( jsonObject as JsonObject ) {
        _jsonObject = jsonObject;
    }

    // Returns a String from a given JsonObject, 
    // or an error message if the value is not present
    public function getString( id as String, errorMessage as String ) as String {
       var value = _jsonObject[id] as String?;
        if( value == null || value.equals( "" ) ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }

    // Returns a String from a given JsonObject, 
    // allowing empty strings, and also returning an empty string
    // if the field is not present
    public function getOptionalString( id as String ) as String {
        var value = _jsonObject[id] as String?;
        if( value == null ) {
            return "";
        } else {
            return value;
        }
    }

    // Returns a Number from a given JsonObject, 
    // or defaults to the passed in def value if the value is not present
    public function getNumber( id as String, def as Number ) as Number {
        var value = _jsonObject[id] as Number?;
        return value == null ? def : value;
    }
    // Returns a Boolean from a given JsonObject, 
    // defaults to false if the value is not present
    public function getBoolean( id as String ) as Boolean {
        var value = _jsonObject[id] as Boolean?;
        return value == null ? false : value;
    }
    
    // Returns another JsonObject from a given JsonObject, 
    // or an error message if the value is not present
    public function getObject( id as String, errorMessage as String ) as JsonAdapter {
        var value = _jsonObject[id] as JsonObject?;
        if( value == null ) {
            throw new JsonParsingException( errorMessage );
        }
        return new JsonAdapter( value );
    }

    // Returns another JsonObject from a given JsonObject, 
    // or an error message if the value is not present
    public function getOptionalObject( id as String ) as JsonAdapter? {
        var value = _jsonObject[id] as JsonObject?;
        if( value != null ) {
            return new JsonAdapter( value );
        } else {
            return null;
        }
    }

    // Returns a JsonArray from a given JsonObject, 
    // or an error message if the value is not present
    public function getArray( id as String, errorMessage as String ) as JsonAdapterArray {
        var value = getOptionalArray( id );
        if( value == null ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }

    // Returns a JsonArray from a given JsonObject, 
    // or an error message if the value is not present
    public function getOptionalArray( id as String ) as JsonAdapterArray? {
        var value = _jsonObject[id] as JsonArray?;
        if( value == null || value.size() == 0 ) {
            return null;
        }
        var result = new JsonAdapterArray[0];
        for( var i = 0; i < value.size(); i++ ) {
            result.add( new JsonAdapter( value[i]) );
        }
        return result;
    }
}