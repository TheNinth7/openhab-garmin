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
    ) as SitemapWidget {

        var type = widget.getString( "type", "Widget without type" ); 

        if( type.equals( "Group" ) ) {
            var groupType = 
                widget.getObject( "item", "Group without item" )
                    .getString( "groupType", "Group item without groupType" );
            switch( groupType ) {
                case "Switch": type = "Switch"; break;
                case "Rollershutter": type = "Switch"; break;
                case "Dimmer": type = "Slider"; break;
                default: type = "Text"; break;
            }
        }

        if( type.equals( "Switch" ) || type.equals( "Selection" ) ) {
            return new SitemapSwitch( widget, isSitemapFresh, asyncProcessing );
        } else if( type.equals( "Setpoint" ) || type.equals( "Slider" ) ) {
            return new SitemapNumeric( widget, isSitemapFresh, asyncProcessing );
        } else if( type.equals( "Text" ) ) {
            return new SitemapText( widget, isSitemapFresh, asyncProcessing );
        } else if( type.equals( "Frame" ) ) {
            return new SitemapFrame( widget, isSitemapFresh, asyncProcessing );
        } else {
            throw new JsonParsingException( "Unsupported element type '" + type + "'." );
        }
    }
}