import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This class represents container elements within the sitemap,
 * such as the homepage and frame elements, which can hold other elements.
 *
 * It supports two modes for creating child elements:
 * - Synchronous: used when no menu is currently displayed and speed is important
 * - Asynchronous: used when a menu is already displayed and UI responsiveness is a priority
 *
 * These two modes are necessary because accessing the dictionaries
 * in which the Garmin SDK packs the JSON data is relatively slow.
 * Processing large structures synchronously can block the UI and
 * lead to noticeable delays in user interaction.
 */
class SitemapPage extends SitemapElement {

    // JSON field names used
    private const WIDGETS = "widgets";
    private const TYPE = "type";

    // The elements of this page
    public var elements as Array<SitemapElement> = new Array<SitemapElement>[0];

    // Constructor
    public function initialize( 
        data as JsonObject, 
        isSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapElement.initialize( data, isSitemapFresh );
        // Loop through all JSON array elements
        var widgets = getArray( data, WIDGETS, "Page '" + label + "': no elements found" );

        if( asyncProcessing ) {
            // For async processing we queue a task
            // TO THE FRONT of the queue (it needs to be 
            // processed before the UI update task that has
            // already been scheduled by `SitemapProcessor`)
            // Because each element is added to the front of
            // the queue, they will be processed in reverse
            // order. Therefore we add the last widget first
            // and then continue down to the first from there
            for( var i = widgets.size() - 1; i >= 0; i-- ) {
                var widget = widgets[i];
                TaskQueue.get().addToFront( 
                    new SitemapPageBuildTask(
                        self,
                        widget,
                        getString( widget, TYPE, "Page '" + label + "': widget without type" )
                    )
                );
            }
        } else {
            // For synchronous processing we create and add the elements 
            // right away, in same the order as in the JSON
            for( var i = 0; i < widgets.size(); i++ ) {
                var widget = widgets[i];
                elements.add( 
                    SitemapElementFactory.createByType( 
                        getString( widget, TYPE, "Page '" + label + "': widget without type" ), 
                        widget,
                        isSitemapFresh,
                        asyncProcessing
                    ) 
                );
            }
        }
    }
}