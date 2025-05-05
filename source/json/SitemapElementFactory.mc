import Toybox.Lang;
import Toybox.WatchUi;

class SitemapElementFactory {

    private static const TYPE_FRAME = "Frame";
    private static const TYPE_SWITCH = "Switch";
    private static const TYPE_TEXT = "Text";

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