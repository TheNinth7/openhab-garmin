import Toybox.Lang;
import Toybox.WatchUi;

/*
    This class is representing elements that hold other elements,
    i.e. the homepage and frames
*/
(:glance)
class SitemapPage extends SitemapElement {

    // JSON field names used
    private const WIDGETS = "widgets";
    private const TYPE = "type";

    // The elements of this page
    public var elements as Array<SitemapElement> = new Array<SitemapElement>[0];

    // The classes representing elements are not available in the glance
    // to save memory. The constructor checks for this and only reads
    // elements if it is not in the glance. However the typechecker/compiler 
    // does not know that and would report an error. Therefore that particular
    // check is disabled, i.e. the typechecker will not verify for this function
    // if all classes are available in glance scope
    (:typecheck(disableGlanceCheck))
    public function initialize( data as JsonObject ) {
        SitemapElement.initialize( data );
        if( ! OHApp.isGlance() ) {
            // Loop through all JSON array elements
            var widgets = getArray( data, WIDGETS, "Page '" + label + "': no elements found" );
            for( var i = 0; i < widgets.size(); i++ ) {
                var widget = widgets[i];
                // Get the factory to create the appropriate element
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