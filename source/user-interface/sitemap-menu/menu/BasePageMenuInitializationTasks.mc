import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This file contains all classes representing asynchronous tasks used to
 * update the menu structure based on a new sitemap.
 */

class CreateMenuItemTask extends BaseSitemapProcessorTask {
    private var _widget as SitemapWidget;
    private var _menu as BasePageMenu;
    private var _weakTaskQueue as WeakReference;

    // Constructor
    public function initialize( 
        widget as SitemapWidget,
        menu as BasePageMenu,
        taskQueue as TaskQueue
    ) {
        BaseSitemapProcessorTask.initialize();
        _widget = widget;
        _menu = menu;
        _weakTaskQueue = taskQueue.weak();
    }

    public function invoke() as Void {
        var taskQueue = _weakTaskQueue.get() as TaskQueue?;
        if( taskQueue == null ) {
            throw new GeneralException( "TaskQueue reference is no longer valid" );
        }
        _menu.addItem( MenuItemFactory.createMenuItem( _widget, _menu, taskQueue ) );
    }
}


