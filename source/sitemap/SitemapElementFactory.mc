import Toybox.Lang;
import Toybox.WatchUi;

/*
    Class for creating the appropriate object for
    a given sitemap element
*/
class SitemapElementFactory {

    // Currently supported element types
    private static const TYPE_FRAME = "Frame";
    private static const TYPE_SWITCH = "Switch";
    private static const TYPE_TEXT = "Text";

    // Create an element for a given type
    public static function createByType( type as String, widget as JsonObject ) as SitemapElement {
        if( type.equals( TYPE_SWITCH ) ) {
            return new SitemapSwitch( widget );
        } else if( type.equals( TYPE_TEXT ) ) {
            return new SitemapText( widget );
        } else if( type.equals( TYPE_FRAME ) ) {
            return new SitemapPage( widget );
        } else {
            throw new JsonParsingException( "Unsupported element type '" + type + "'." );
        }
    }
}