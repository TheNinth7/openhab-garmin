import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Task for updating a menu item with the id of a given sitemap element,
 * or adding the menu item if it is not yet present
 */
class AddOrUpdateMenuItemTask extends BaseSitemapProcessorTask {
    private var _sitemapElement as SitemapElement;
    private var _pageMenu as BasePageMenu;

    // Constructor
    public function initialize( 
        sitemapElement as SitemapElement,
        pageMenu as BasePageMenu 
    ) {
        BaseSitemapProcessorTask.initialize();
        _pageMenu = pageMenu;
        _sitemapElement = sitemapElement;
    }
    
    // Add the element
    public function invoke() as Void {
        var itemIndex = _pageMenu.findItemById( _sitemapElement.id );
        if( itemIndex == -1 ) {
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
            var item = _pageMenu.getItem( itemIndex ) as BaseSitemapMenuItem;
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
                _pageMenu.updateItem( newItem, itemIndex );
            }
        }
    }
}

/*
 * Task for deleting all menu items that are not needed anymore
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


// A bug in Garmin's native device implementation of the CustomMenu/Menu2
// affects updates to the currently displayed menu:
// - added menu items are not displayed,
// - and even worse, deleting menu items leads to an app crash
// This can be avoided by replacing the current view with itself,
// using switchToView. This seems to trigger the necessary refresh
// inside the CustomMenu to properly handle the changed number of items.
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