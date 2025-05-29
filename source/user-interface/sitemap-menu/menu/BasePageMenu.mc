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
 *
 * Since updates can take time and CIQ apps are single-threaded, the update 
 * is broken into multiple tasks. These tasks are managed by the TaskQueue, 
 * allowing gaps between them for user input to be processed. This avoids 
 * noticeable lag or UI unresponsiveness when handling large sitemaps.
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
    *
    * The update() function also tracks whether the update affected the structure.
    * See invalidateStructure() for more details.
    */
    public function update( sitemapPage as SitemapPage ) as Void {
        // Logger.debug( "PageMenu.update: updating page '" + _label + "'" );

        // Update the title of the menu
        _label = sitemapPage.label;
        setTitleAsString( _label );

        // The update is done by asynchronously executed tasks
        var taskQueue = TaskQueue.get();

        // Since the `SitemapProcessor` has already added tasks that should run
        // AFTER the menu update, we prepend all tasks to the queue.
        // As a result, the tasks here are added in REVERSE order of their
        // intended execution. For example, we add the `SwitchViewIfItemCountChangedTask`
        // first, because it is meant to be executed last.

        // Workaround for a bug in Garmin's native device implementation 
        // of the CustomMenu/Menu2. See `SwitchViewIfItemCountChangedTask`
        // for details. This task needs to be created before any modifications
        // to the menu structure, because on initialization it needs to save the
        // current number of menu items.
        taskQueue.addToFront( new SwitchViewIfItemCountChangedTask( self ) );

        // After we have cycled through all sitemap elements, 
        // we'll delete any menu items that are not used anymore
        taskQueue.addToFront( new DeleteUnusedMenuItemsTask( sitemapPage, self ) );

        // Loop through all elements in the new sitemap state
        // and add a task for each to process them.
        // We do this in reverse order so that the tasks are
        // executed in the same order as the corresponding sitemap elements.
        var elements = sitemapPage.elements;
        for( var i = elements.size() - 1; i >= 0; i-- ) {
            var element = elements[i];
            taskQueue.addToFront( new AddOrUpdateMenuItemTask( element, self ) );
        }
    }
}