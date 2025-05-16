import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class for creating the appropriate object 
 * based on a given sitemap element.
 */
class SitemapElementFactory {

    // Create an element for a given type
    public static function createByType( type as String, widget as JsonObject ) as SitemapElement {
        if( type.equals( "Switch" ) ) {
            return new SitemapSwitch( widget );
        } else if( type.equals( "Slider" ) ) {
            return new SitemapSlider( widget );
        } else if( type.equals( "Text" ) ) {
            return new SitemapText( widget );
        } else if( type.equals( "Frame" ) ) {
            return new SitemapPage( widget );
        } else {
            throw new JsonParsingException( "Unsupported element type '" + type + "'." );
        }
    }
}