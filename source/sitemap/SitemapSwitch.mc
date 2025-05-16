import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Switch` elements.
 */

// Class representing the command mappings of a Switch
class CommandMapping {
    public var command as String;
    public var label as String;
    public function initialize( c as String, l as String ) {
        command = c;
        label = l;
    }
}
// An array of command mappings
typedef CommandMappingArray as Array<CommandMapping>;

class SitemapSwitch extends SitemapPrimitiveElement {
    // Command mappings from the JSON
    public var mappings as CommandMappingArray = [];

    // Accessor
    public function hasMappings() as Boolean {
        return mappings.size() > 0;
    }

    public function initialize( data as JsonObject ) {
        SitemapPrimitiveElement.initialize( data );
        var jsonMappings = data["mappings"] as JsonArray?;
        if( jsonMappings != null ) {
            for( var i = 0; i < jsonMappings.size(); i++ ) {
                var jsonMapping = jsonMappings[i];
                mappings.add(
                    new CommandMapping( 
                        getString( jsonMapping, "command", "Element '" + label + "': command is missing from mapping" ),
                        getString( jsonMapping, "label", "Element '" + label + "': label is missing from mapping" )
                ) );
            }
        }
    }
}