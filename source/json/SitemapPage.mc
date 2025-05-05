import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class SitemapPage extends SitemapElement {

    private const WIDGETS = "widgets";
    private const TYPE = "type";

    public var elements as Array<SitemapElement> = new Array<SitemapElement>[0];

    (:typecheck(disableGlanceCheck))
    public function initialize( data as JsonObject ) {
        SitemapElement.initialize( data );
        if( ! OHApp.isGlance() ) {
            var widgets = getArray( data, WIDGETS, "Page '" + label + "': no elements found" );
            for( var i = 0; i < widgets.size(); i++ ) {
                var widget = widgets[i];
                elements.add( 
                    SitemapElementFactory.createByType( 
                        getString( widget, TYPE, "Page '" + label + "': widget without type" ), 
                        widget 
                    ) 
                );
            }
        }
    }
}