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
    private var _widgets as Array<SitemapWidget> = new Array<SitemapWidget>[0];

    // Constructor
    public function initialize( 
        json as JsonAdapter, 
        isSitemapFresh as Boolean,
        taskQueue as TaskQueue
    ) {
        SitemapElement.initialize( isSitemapFresh );

        // Loop through all JSON array elements
        var jsonWidgets = json.getArray( "widgets", "Frame or page contains no elements" );

        // We queue tasks at the FRONT of the queue because they must be processed
        // before previously scheduled tasks (e.g., UI updates already scheduled by `SitemapProcessor`).
        // Since each task is added to the front, the order of execution is reversed —
        // the last widget added will be processed first. Therefore, we add widgets
        // in reverse order: starting with the last and ending with the first.
        for( var i = jsonWidgets.size() - 1; i >= 0; i-- ) {
            var jsonWidget = jsonWidgets[i];
            taskQueue.addToFront( 
                new SitemapContainerBuildTask(
                    self,
                    jsonWidget,
                    taskQueue
                )
            );
        }
    }

    // Adds a widget, used by the build task
    public function addWidget( widget as SitemapWidget ) as Void {
        _widgets.add( widget );
    }

    // Returns the elements of this page
    public function getWidgets() as Array<SitemapWidget> {
        return _widgets;
    }
}