import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

/*
 * Base class for page menus.
 *
 * Page menus act as containers for primitive sitemap elements. 
 * These containers correspond to elements like the Homepage and Frames, 
 * while primitive elements include items such as Switches and Text elements.
 *
 * This class handles both the creation of menu items based on the sitemap 
 * and the logic for updating the menu in response to changes in the sitemap.
 */
class BasePageMenu extends BaseMenu {
    
    // The label for the menu
    private var _label as String;
    public function getLabel() as String {
        return _label;
    }

    // The menu structure remains valid after an update as long as
    // no pages are added or removed anywhere in the tree.
    //
    // If the structure becomes invalid (e.g., due to page additions or deletions),
    // the view is reset to the Homepage. This ensures we don't remain in a submenu
    // that may have been deleted or changed to a different menu item type.
    //
    // This function is implemented differently by HomepageMenu and PageMenu:
    // - HomepageMenu stores a Boolean flag indicating if the structure is still valid.
    // - PageMenu delegates this check to its parent.
    public function invalidateStructure() as Void {
        throw new AbstractMethodException( "BasePageMenu.invalidateStructure" );
    }

    // Constructor
    protected function initialize( 
        sitemapPage as SitemapPage, 
        footer as Drawable?
    ) {
        _label = sitemapPage.label;
        
        // Initialize the super class
        BaseMenu.initialize( {
                :title => _label,
                :itemHeight => Constants.UI_MENU_ITEM_HEIGHT,
                :footer => footer
            } );

        // For each element in the page, create a menu item
        var elements = sitemapPage.elements;
        for( var i = 0; i < elements.size(); i++ ) {
            BasePageMenu.addItem( MenuItemFactory.createMenuItem( elements[i], self ) );
        }
    }

    /*
    * Updates the menu based on a new sitemap state.
    *
    * Returns `true` if the overall menu structure remains unchanged (i.e., no pages or frames 
    * were added or removed). If the structure has changed, the function returns `false`, and 
    * the view will reset to the `HomepageMenu` after the update.
    *
    * Sitemap-assigned identifiers are effectively positional indexes. When a new element is 
    * inserted in the middle of a page, it receives the identifier previously assigned to the 
    * item at that position, and subsequent items are reindexed accordingly.
    *
    * The update algorithm compares each new sitemap element with the existing menu item at 
    * the corresponding position:
    *   - If the types match, the item is updated in place.
    *   - If the types differ, the existing item is replaced.
    *   - If no matching menu item exists for a given index, a new one is added.
    *   - If any existing menu items remain after processing all sitemap elements, they are removed.
    *
    * This allows for efficient repurposing of menu items when changes are made mid-list, provided 
    * the types are compatible. For example, inserting a `Switch` in the middle of a list of `Switch` 
    * items will cause the menu item at that position to be reused for the new `Switch`, and subsequent 
    * items will be repurposed or extended as needed.
    */
    public function update( sitemapPage as SitemapPage ) as Void {
        // Logger.debug( "PageMenu.update: updating page '" + _label + "'" );

        // Update the title of the menu
        _label = sitemapPage.label;
        setTitleAsString( _label );

        var taskQueue = TaskQueue.get();

        // A bug in Garmin's native device implementation of the CustomMenu/Menu2
        // affects updates to the currently displayed menu:
        // - added menu items are not displayed,
        // - and even worse, deleting menu items leads to an app crash
        // This can be avoided by replacing the current view with itself,
        // using switchToView. This seems to trigger the necessary refresh
        // inside the CustomMenu to properly handle the changed number of items.
        taskQueue.addToFront( new SwitchViewIfItemCountChangedTask( self ) );

        taskQueue.addToFront( new DeleteUnusedMenuItemsTask( sitemapPage, self ) );

        // Loop through all elements in the new sitemap state
        var elements = sitemapPage.elements;
        for( var i = elements.size() - 1; i >= 0; i-- ) {
            var element = elements[i];
            taskQueue.addToFront( new AddOrUpdateMenuItemTask( element, self ) );
        }
    }
}