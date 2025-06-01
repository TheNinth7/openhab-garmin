import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This file contains all classes representing asynchronous tasks used to
 * update the menu structure based on a new sitemap.
 *
 * The update process involves the following tasks:
 *
 * 1) AddOrUpdateMenuItemTask
 *    Processes a single sitemap element, updating the corresponding menu item
 *    by ID or adding it if it does not yet exist. See BasePageMenu.update() for details.
 *
 * 2) DeleteUnusedMenuItemsTask
 *    Removes any menu items that no longer have a corresponding sitemap element.
 *
 * 3) SwitchViewIfItemCountChangedTask
 *    Implements a workaround for a Garmin SDK bug. See the class description for details.
 */

/*
 * Task for updating the menu item with the ID of a given sitemap element,
 * or adding it if it does not already exist.
 *
 * Sitemap-assigned identifiers are effectively positional indexes. When a new element is 
 * inserted in the middle of a page, it receives the identifier previously assigned to the 
 * item at that position, and subsequent items are reindexed accordingly.
 *
 * Therefore this task has to deal with different cases:
 *   - If the types match, the item is updated in place.
 *   - If the types differ, the existing item is replaced.
 *   - If no matching menu item exists for a given index, a new one is added.
 * 
 * See also BasePageMenu.update() for further information on the update algorithm.
 */
class AddOrUpdateMenuItemTask extends BaseSitemapProcessorTask {
    private var _index as Number;
    private var _sitemapElement as SitemapElement;
    private var _pageMenu as BasePageMenu;

    // Constructor
    public function initialize( 
        index as Number,
        sitemapElement as SitemapElement,
        pageMenu as BasePageMenu 
    ) {
        BaseSitemapProcessorTask.initialize();
        _index = index;
        _sitemapElement = sitemapElement;
        _pageMenu = pageMenu;
    }
    
    // Add the element
    public function invoke() as Void {
        if( _index >= _pageMenu.getItemCount() ) {
            // If the item does not exist yet, we create it
            _pageMenu.addItem( 
                MenuItemFactory.createMenuItem( 
                    _sitemapElement, 
                    _pageMenu 
                ) 
            );
            // Logger.debug( "PageMenu.update: adding new item to page '" + _pageMenu.getLabel() + "'" );
        } else {
            // If the item is found, we check if the type of the menu
            // item is the same or has changed
            var item = _pageMenu.getItem( _index ) as BaseSitemapMenuItem;
            if( item.isMyType( _sitemapElement ) ) {
                // If the type is the same, we update the menu item
                item.update( _sitemapElement );
            } else {
                // If the type is not the same, we create a new item
                // and replace the existing menu item with it
                var newItem = MenuItemFactory.createMenuItem( 
                    _sitemapElement, 
                    _pageMenu 
                );

                if( item instanceof PageMenuItem || newItem instanceof PageMenuItem ) {
                    _pageMenu.invalidateStructure();
                    // Logger.debug( "PageMenu.update: page '" + _pageMenu.getLabel() + "' invalid because item '" + item.getLabel() + "' changed type from/to page" );

                }
                _pageMenu.updateItem( newItem, _index );
            }
        }
    }
}

/*
 * If any existing menu items remain after processing all sitemap elements, 
 * they are removed.
 */
class DeleteUnusedMenuItemsTask extends BaseSitemapProcessorTask {
    private var _pageMenu as BasePageMenu;
    private var _sitemapPage as SitemapPage;

    // Constructor
    public function initialize( 
        sitemapPage as SitemapPage,
        pageMenu as BasePageMenu 
    ) {
        BaseSitemapProcessorTask.initialize();
        _pageMenu = pageMenu;
        _sitemapPage = sitemapPage;
    }
    
    // Delete the unused menu items
    public function invoke() as Void {
        // The number of used menu items equals to the number
        // of sitemap elements. So number of elements equals
        // to the first UNUSED index.
        var i = _sitemapPage.elements.size();
        // Logger.debug( "DeleteUnusedMenuItemsTask.invoke: deleting menu item, starting from index " + i );

        // NOTE: getItemCount() receives special handling in `HomepageMenu`
        // for touch-based devices. It effectively hides the settings menu entry
        // by returning the item count excluding it, in order to prevent the
        // entry from being deleted as an unused menu item.
        while( i < _pageMenu.getItemCount() ) {
            var menuItem = _pageMenu.getItem( i ) as CustomMenuItem;
            if( menuItem instanceof PageMenuItem ) {
                _pageMenu.invalidateStructure();
                // Logger.debug( "PageMenu.update: page '" + _sitemapPage.label + "' invalid because subpage was removed" );
            }
            _pageMenu.deleteItem( i );
        }
    }
}


/*
 * A bug in Garmin's native device implementation of CustomMenu/Menu2
 * affects updates to the currently displayed menu:
 * - Newly added menu items are not displayed.
 * - Even worse, deleting menu items can cause the app to crash.
 *
 * This issue can be avoided by replacing the current view with itself
 * using switchToView(). This appears to trigger the necessary refresh
 * inside CustomMenu to properly handle the updated number of items.
 */
class SwitchViewIfItemCountChangedTask extends BaseSitemapProcessorTask {
    private var _pageMenu as BasePageMenu;
    private var _previousItemCount as Number;

    // Constructor
    // The task needs to be created before any modification
    // of the BasePageMenu. It will record the current number
    // of items, and compare that with the number of items on
    // invokation.
    public function initialize( 
        pageMenu as BasePageMenu 
    ) {
        BaseSitemapProcessorTask.initialize();
        _pageMenu = pageMenu;
        _previousItemCount = pageMenu.getItemCount();
    }
    
    // Add the element
    public function invoke() as Void {
        // Logger.debug( "SwitchViewIfItemCountChangedTask.invoke" );
        // Replacing items works as expected, so only when 
        // the item count has changed ...
        if( _previousItemCount != _pageMenu.getItemCount() ) {
            // Logger.debug( "SwitchViewIfItemCountChangedTask.invoke: item count has changed" );
            // ... and this menu is the current view ...
            if( _pageMenu.equals( WatchUi.getCurrentView()[0] ) ) {
                // Logger.debug( "SwitchViewIfItemCountChangedTask.invoke: switching the view!" );
                
                // ... we do the switch to itself
                WatchUi.switchToView(
                    WatchUi.getCurrentView()[0] as View,
                    WatchUi.getCurrentView()[1] as InputDelegate,
                    WatchUi.SLIDE_IMMEDIATE
                );
            }            
        }
    }
}