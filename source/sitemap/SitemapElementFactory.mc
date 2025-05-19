import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class for creating the appropriate object 
 * based on a given sitemap element.
 */
class SitemapElementFactory {

    // Create an element for a given type
    public static function createByType( type as String, widget as JsonObject, isStateFresh as Boolean ) as SitemapElement {
        if( type.equals( "Switch" ) ) {
            return new SitemapSwitch( widget, isStateFresh );
        } else if( type.equals( "Slider" ) ) {
            return new SitemapSlider( widget, isStateFresh );
        } else if( type.equals( "Text" ) ) {
            return new SitemapText( widget, isStateFresh );
        } else if( type.equals( "Frame" ) ) {
            return new SitemapPage( widget, isStateFresh );
        } else {
            throw new JsonParsingException( "Unsupported element type '" + type + "'." );
        }
    }
}