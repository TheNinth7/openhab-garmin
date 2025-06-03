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
    private var _title as String;
    public function getTitle() as String {
        return _title;
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
        sitemapContainer as SitemapContainerImplementation, 
        footer as Drawable?
    ) {
        _title = sitemapContainer.title;
        
        // Initialize the super class
        BaseMenu.initialize( {
                :title => _title,
                :itemHeight => Constants.UI_MENU_ITEM_HEIGHT,
                :footer => footer
            } );

        // For each element in the page, create a menu item
        var widgets = sitemapContainer.widgets;
        for( var i = 0; i < widgets.size(); i++ ) {
            BasePageMenu.addItem( MenuItemFactory.createMenuItem( widgets[i], self ) );
        }
    }

    /*
    * Updates the menu based on the current sitemap state.
    *
    * This algorithm uses positional indexing based on the order of elements in the sitemap JSON.
    * When a new element is inserted mid-page, it receives the identifier previously assigned
    * to the item at that position, and all subsequent items are reindexed accordingly.
    *
    * For each sitemap element, the algorithm compares it to the existing menu item at the same index:
    *   - If types match, the item is updated in place.
    *   - If types differ, the existing item is replaced.
    *   - If no menu item exists at that index, a new one is added.
    *   - Any remaining items beyond the end of the new sitemap list are removed.
    *
    * This enables efficient reuse of menu items when elements are added, removed, or reordered— 
    * as long as the types are compatible. For example, inserting a `Switch` in the middle of a list 
    * of `Switch` items will repurpose the existing item at that position and adjust the rest accordingly.
    *
    * The `update()` function also tracks whether the menu structure was affected.
    * See `invalidateStructure()` for details.
    *
    * NOTE: This algorithm does *not* use the `widgetId`. While `widgetId` often reflects the 
    * position of an element, this breaks down when the `visibility` parameter is used—hidden items 
    * retain their `widgetId`, creating "holes" in the sequence. To avoid this, we rely on actual 
    * array indices instead.
    */
    public function update( sitemapContainer as SitemapContainerImplementation ) as Void {
        // Logger.debug( "PageMenu.update: updating page '" + _title + "'" );

        // Update the title of the menu
        _title = sitemapContainer.title;
        setTitleAsString( _title );

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
        taskQueue.addToFront( 
            new DeleteUnusedMenuItemsTask( 
                sitemapContainer as SitemapContainer, 
                self 
            ) 
        );

        // Loop through all elements in the new sitemap state
        // and add a task for each to process them.
        // We do this in reverse order so that the tasks are
        // executed in the same order as the corresponding sitemap elements.
        var widgets = sitemapContainer.widgets;
        for( var i = widgets.size() - 1; i >= 0; i-- ) {
            var widget = widgets[i];
            taskQueue.addToFront( new AddOrUpdateMenuItemTask( i, widget, self ) );
        }
    }
}