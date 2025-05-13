import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Switch` elements.
 */
class SitemapSwitch extends SitemapPrimitiveElement {
    // JSON field names
    private const MAPPINGS = "mappings";
    private const MAPPINGS_COMMAND = "command";
    private const MAPPINGS_LABEL = "label";

    // Fields read from the JSON
    public var mappings as Array<CommandMapping> = [];

    // Accessor
    public function hasMappings() as Boolean {
        return mappings.size() > 0;
    }

    public function initialize( data as JsonObject ) {
        SitemapPrimitiveElement.initialize( data );
        var jsonMappings = data[MAPPINGS] as JsonArray?;
        if( jsonMappings != null ) {
            for( var i = 0; i < jsonMappings.size(); i++ ) {
                var jsonMapping = jsonMappings[i];
                mappings.add(
                    new CommandMapping( 
                        getString( jsonMapping, MAPPINGS_COMMAND, "Element '" + label + "': command is missing from mapping" ),
                        getString( jsonMapping, MAPPINGS_LABEL, "Element '" + label + "': label is missing from mapping" )
                ) );
            }
        }
    }
}

class CommandMapping {
    public var command as String;
    public var label as String;
    public function initialize( c as String, l as String ) {
        command = c;
        label = l;
    }
}