import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class for creating the appropriate object 
 * based on a given sitemap element.
 */
class SitemapWidgetFactory {

    // Create an element for a given type
    public static function createByType( 
        widget as JsonAdapter, 
        isSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) as SitemapElement {
        var type = widget.getString( "type", "Widget without type" ); 
        if( type.equals( "Switch" ) ) {
            return new SitemapSwitch( widget, isSitemapFresh );
        } else if( type.equals( "Slider" ) ) {
            return new SitemapSlider( widget, isSitemapFresh );
        } else if( type.equals( "Text" ) ) {
            return new SitemapText( widget, isSitemapFresh );
        } else if( type.equals( "Frame" ) ) {
            return new SitemapPage( widget, isSitemapFresh, asyncProcessing );
        } else {
            throw new JsonParsingException( "Unsupported element type '" + type + "'." );
        }
    }
}