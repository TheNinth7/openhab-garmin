import Toybox.Lang;
import Toybox.WatchUi;

class SitemapPage extends SitemapElement {

    private const WIDGETS = "widgets";
    private const TYPE = "type";
    private const TYPE_FRAME = "Frame";
    private const TYPE_SWITCH = "Switch";

    public var elements as Array<SitemapElement> = new Array<SitemapElement>[0];

    function initialize( data as JsonObject ) {
        SitemapElement.initialize( data );
        var widgets = getArray( data, WIDGETS, "Page '" + label + "': no elements found!" );

        for( var i = 0; i < widgets.size(); i++ ) {
            var widget = widgets[i];
            var type = getString( widget, TYPE, "Page '" + label + "': widget without type!" );
            if( type.equals( TYPE_SWITCH ) ) {
                elements.add( new SitemapSwitch( widget ) );
            } else if( type.equals( TYPE_FRAME ) ) {
                elements.add( new SitemapPage( widget ) );
            } else {
                throw new JsonParsingException( "Page '" + label + "': please remove unsupported element type '" + type + "'." );
            }
        }
    }
}