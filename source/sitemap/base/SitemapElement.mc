import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for all sitemap elements.
 */

// Types representing dictionary and array objects used for JSON structures 
// sent to or received from web requests.
typedef JsonObject as Dictionary<String,Object?>;
typedef JsonArray as Array<JsonObject>;

class SitemapElement {

    // Default field names for id and label
    // The homepage uses different fields for this by
    // overriding these variables
    public var ID as String = "widgetId";
    public var LABEL as String = "label";

    // Color fields
    private const LABEL_COLOR = "labelcolor";
    private const VALUE_COLOR = "valuecolor";

    // The id and label of this instance
    public var id as Object;
    public var label as String;

    public var labelColor as ColorType?;
    public var valueColor as ColorType?;
    
    // Indicates whether the state is fresh
    // If received via web request, it is always considered
    // fresh, if read from storage it depends on the data's age
    public var isSitemapFresh as Boolean;

    // Constructor
    protected function initialize( data as JsonObject, initStateFresh as Boolean ) {
        // Reading the id and label from the JSON element
        isSitemapFresh = initStateFresh;
        id = getString( data, ID, "Sitemap element: no " + ID + " found" );
        label = getString( data, LABEL, "Sitemap element: no " + LABEL + " found" );
        labelColor = getOptionalColor( data, LABEL_COLOR );
        valueColor = getOptionalColor( data, VALUE_COLOR );
    }

    // Returns a String from a given JsonObject, 
    // or an error message if the value is not present
    public function getString( data as JsonObject, id as String, errorMessage as String ) as String {
       var value = data[id] as String?;
        if( value == null || value.equals( "" ) ) {
            throw new JsonParsingException( errorMessage );
        }
        return value;
    }

    // Returns a String from a given JsonObject, 
    // allowing empty strings, and also returning an empty string
    // if the field is not present
    protected function getOptionalString( data as JsonObject, id as String ) as String {
        var value = data[id] as String?;
        if( value == null ) {
            return "";
        } else {
            return value;
        }
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

    // Get an optional color value
    private function getOptionalColor( data as JsonObject, id as String ) as ColorType? {
        var colorString = data[id] as String?;
        if( colorString == null || colorString.equals( "" ) ) {
            return null;
        }
        switch ( colorString ) {
            case "maroon": return 0x800000;
            case "red": return 0xff0000;
            case "orange": return 0xffa500;
            case "olive": return 0x808000;
            case "yellow": return 0xffff00;
            case "purple": return 0x800080;
            case "fuchsia": return 0xff00ff;
            case "pink": return 0xffc0cb;
            case "white": return 0xffffff;
            case "lime": return 0x00ff00;
            case "green": return 0x008000;
            case "navy": return 0x000080;
            case "blue": return 0x0000ff;
            case "teal": return 0x008080;
            case "aqua": return 0x00ffff;
            case "black": return 0x000000;
            case "silver": return 0xc0c0c0;
            case "gray": return 0x808080;
            case "gold": return 0xffd700;
        }
        var leadChar = colorString.substring( null, 1);
        if( leadChar != null && leadChar.equals( "#" ) ) {
            colorString = colorString.substring( 1, null );
            if( colorString != null ) {
                var colorNumber = ( colorString ).toNumberWithBase( 0x10 );
                if( colorNumber != null ) {
                    if( colorNumber >= 0 && colorNumber <= 16777215 ) {
                        return colorNumber;
                    }
                }
            }
        }
        throw new JsonParsingException( "Invalid color value '" + colorString + "' for element'" + label + "'" );
    }
}