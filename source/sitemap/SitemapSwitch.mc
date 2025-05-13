import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Switch` elements.
 */
class SitemapSwitch extends SitemapPrimitiveElement {
    // JSON field names
    private const MAPPINGS = "mappings";

    // Fields read from the JSON
    public var mappings as JsonArray?;

    // Accessor
    public function hasMappings() as Boolean {
        return mappings != null && mappings.size() > 0;
    }

    public function initialize( data as JsonObject ) {
        SitemapPrimitiveElement.initialize( data );
        mappings = data[MAPPINGS] as JsonArray?;
    }
}