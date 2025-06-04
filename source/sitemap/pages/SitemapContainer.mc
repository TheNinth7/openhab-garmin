import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This class represents container elements within the sitemap,
 * such as the homepage, other pages and frame elements. Containers
 * can hold multiple widgets.
 *
 * It supports two modes for creating widget elements:
 * - Synchronous: used when no menu is currently displayed and speed is important
 * - Asynchronous: used when a menu is already displayed and UI responsiveness is a priority
 *
 * These two modes are necessary because accessing the dictionaries
 * in which the Garmin SDK packs the JSON data is relatively slow.
 * Processing large structures synchronously can block the UI and
 * lead to noticeable delays in user interaction.
 */

// This type can be used as generic type for all implementations
// This is needed for accessing members that are not provided by
// SitemapContainer, but still are common to all implementations (=title)
typedef SitemapContainerImplementation as 
    SitemapPage or 
    SitemapFramePage;

class SitemapContainer extends SitemapElement {

    // The elements of this page
    public var widgets as Array<SitemapWidget> = new Array<SitemapWidget>[0];

    // Constructor
    public function initialize( 
        json as JsonAdapter, 
        initSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapElement.initialize( initSitemapFresh );

        // Loop through all JSON array elements
        var jsonWidgets = json.getArray( "widgets", "Frame or page contains no elements" );

        if( asyncProcessing ) {
            // For async processing we queue a task
            // TO THE FRONT of the queue (it needs to be 
            // processed before the UI update task that has
            // already been scheduled by `SitemapProcessor`)
            // Because each element is added to the front of
            // the queue, they will be processed in reverse
            // order. Therefore we add the last widget first
            // and then continue down to the first from there
            for( var i = jsonWidgets.size() - 1; i >= 0; i-- ) {
                var jsonWidget = jsonWidgets[i];
                TaskQueue.get().addToFront( 
                    new SitemapContainerBuildTask(
                        self,
                        jsonWidget
                    )
                );
            }
        } else {
            // For synchronous processing we create and add the elements 
            // right away, in same the order as in the JSON
            for( var i = 0; i < jsonWidgets.size(); i++ ) {
                var jsonWidget = jsonWidgets[i];
                widgets.add( 
                    SitemapWidgetFactory.createByType( 
                        jsonWidget,
                        initSitemapFresh,
                        asyncProcessing
                    ) 
                );
            }
        }
    }
}