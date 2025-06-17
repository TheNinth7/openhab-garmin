import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This file contains all classes representing asynchronous tasks used to
 * update the menu structure based on a new sitemap.
 */

class CreateMenuItemTask extends BaseSitemapProcessorTask {
    private var _widget as SitemapWidget;
    private var _menu as BasePageMenu;
    private var _taskQueue as TaskQueue;

    // Constructor
    public function initialize( 
        widget as SitemapWidget,
        menu as BasePageMenu,
        taskQueue as TaskQueue
    ) {
        BaseSitemapProcessorTask.initialize();
        _widget = widget;
        _menu = menu;
        _taskQueue = taskQueue;
    }

    public function invoke() as Void {
        _menu.addItem( MenuItemFactory.createMenuItem( _widget, _menu, _taskQueue ) );
    }
}


