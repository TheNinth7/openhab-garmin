import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This class represents container elements within the sitemap,
 * such as the homepage and frame elements, which can hold other elements.
 */
class SitemapPage extends SitemapElement {

    // JSON field names used
    private const WIDGETS = "widgets";
    private const TYPE = "type";

    // The elements of this page
    public var elements as Array<SitemapElement> = new Array<SitemapElement>[0];

    /*
    * Primitve element classes are not available in the glance view to conserve memory.
    * The constructor accounts for this by only reading elements when not in glance mode.
    *
    * However, the typechecker/compiler is unaware of this runtime check and would 
    * otherwise report an error due to missing classes. To prevent this, type checking 
    * is explicitly disabled for this function in glance scope.
    */
    public function initialize( data as JsonObject, isSitemapFresh as Boolean ) {
        SitemapElement.initialize( data, isSitemapFresh );
        // Loop through all JSON array elements
        var widgets = getArray( data, WIDGETS, "Page '" + label + "': no elements found" );
        for( var i = 0; i < widgets.size(); i++ ) {
            var widget = widgets[i];
            // Get the factory to create the appropriate element
            elements.add( 
                SitemapElementFactory.createByType( 
                    getString( widget, TYPE, "Page '" + label + "': widget without type" ), 
                    widget,
                    isSitemapFresh 
                ) 
            );
        }
    }
}