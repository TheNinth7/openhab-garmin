import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
 * `HomepageMenu` represents the root of the sitemap and is implemented as a singleton,
 * as there can only be one root.
 *
 * It behaves similarly to a standard `PageMenu`, but includes additional functionality
 * for accessing the settings menu.
 *
 * - On button-based devices: the settings menu is accessed by scrolling past the
 *   header or footer of the menu (i.e., it's a parallel menu).
 * - On touch-based devices: the settings menu is accessed via a dedicated menu item.
 *
 * Some functions in this class are specific to either button-based or touch-based devices,
 * and are conditionally excluded from compilation for the other device type.
 */
class HomepageMenu extends BasePageMenu {
    

    /******* STATIC *******/


    // The Singleton instance
    private static var _instance as HomepageMenu?;
    
    // Completely removes the current menu structure.
    // Used to start fresh after out-of-memory errors,
    // which can occur if old and new sitemaps differ greatly
    // and their menu structures partially coexist during updates.
    public static function clear() as Void {
        _instance = null;
    }

    // Creates the menu from a sitemap.
    // This function uses a synchronous task queue to iterate over the entire sitemap,
    // instead of relying on recursive function calls. CIQ apps have a relatively small
    // maximum stack size, so this approach helps avoid stack overflow errors when
    // processing sitemaps with many levels of hierarchy.
    public static function create( sitemapHomepage as SitemapHomepage, asyncProcessing as Boolean ) as HomepageMenu {
        if( _instance == null ) {
            _instance = new HomepageMenu( sitemapHomepage, asyncProcessing );
        }
        return _instance as HomepageMenu;
    }
    
    // This function is called on startup by OHApp, and 
    // if available initializes the menu from sitemap data
    // in storage
    public static function createFromStorage() as HomepageMenu? {
        var homepageMenu = null;
        // Reading the JSON from storage is not critical,
        // if it fails, we just move ahead and request it from the server
        try {
            var sitemapHomepage = SitemapStore.getSitemapFromStorage();
            if( sitemapHomepage != null ) {
                homepageMenu = HomepageMenu.create( sitemapHomepage, false );
            }
        } catch( ex ) {
            Logger.debugException( ex );
        }
        return homepageMenu;
    }

    // True if the menu was already created
    public static function exists() as Boolean {
        return _instance != null;
    }

    // Returns the menu, or throws an exception if
    // the menu was not created yet
    public static function get() as HomepageMenu {
        if( _instance == null ) {
            throw new GeneralException( "HomepageMenu: call create() before get()" );
        }
        return _instance as HomepageMenu;
    }

    
    /******* INSTANCE *******/


    // See BasePageMenu.invalidateStructure for details
    private var _structureRemainsValid as Boolean = true;
    
    // See BasePageMenu.invalidateStructure for details
    public function invalidateStructure() as Void {
        _structureRemainsValid = false;
    }

    // The HomepageMenu is the entry point into the
    // menu structure, where we want to display toast notifications for
    // non-fatal errors
    public function onShow() as Void {
        ToastHandler.setUseToasts( true );
    }

    // See BasePageMenu.invalidateStructure for details
    public function structureRemainsValid() as Boolean {
        return _structureRemainsValid;
    }

    // Before an update we reset the indicator showing whether
    // the update left the structure intact.
    // Then we call the update function of the base class
    public function update( sitemapContainer as SitemapContainerImplementation ) as Void {
        _structureRemainsValid = true;
        BasePageMenu.update( sitemapContainer );
    }

    // On button-based devices, the settings icon is displayed in the footer
    (:exclForTouch)
    private function initialize(
        sitemapHomepage as SitemapHomepage,
        asyncProcessing as Boolean
    ) {
        var taskQueue = 
            asyncProcessing
            ? AsyncTaskQueue.get()
            : new SyncTaskQueue();

        BasePageMenu.initialize( 
            sitemapHomepage, 
            new Bitmap( {
                    :rezId => Rez.Drawables.iconDownToSettings,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } ),
            taskQueue
        );

        // The base class always creates tasks to process its elements
        // If synchronous processing has been requested, we execute
        // those tasks immediately.
        // Processing the elements sequentially instead of recursively
        // is needed to avoid stack overflow withs larger sitemaps
        if( taskQueue instanceof SyncTaskQueue ) {
            taskQueue.executeTasks();
        }
    }

    // For touch-based devices there is a dedicated menu item for
    // showing the settings menu
    // This member tracks whether the settings menu has been added
    (:exclForButton)
    private var _hasSettingsMenu as Boolean = false;
    (:exclForButton)
    private function initialize(
        sitemapHomepage as SitemapHomepage,
        syncTaskQueue as SyncTaskQueue 
    ) {
        BasePageMenu.initialize( sitemapHomepage, null, syncTaskQueue );
        BasePageMenu.addItem( SettingsMenuItem.get() );
        _hasSettingsMenu = true;
    }
    // The update function syncs the menu structure with the sitemap
    // The following two functions are overriden to "hide" the last
    // entry, the settings menu item, from the update procedure
    // We pretent to have one menu item less ...
    (:exclForButton) 
    public function getItemCount() as Number {
        return 
            _hasSettingsMenu
            ? BasePageMenu.getItemCount() - 1
            : BasePageMenu.getItemCount();
    }
    // And if a menu item is added, we first remove the settings,
    // then add the new menu item, and then add the settings again
    // in the end
    (:exclForButton) 
    public function addItem( menuItem as CustomMenuItem ) as Void {
        var accountForSettingsMenu = _hasSettingsMenu;
        if( accountForSettingsMenu ) {
            BasePageMenu.deleteItem( BasePageMenu.getItemCount() - 1 );
            _hasSettingsMenu = false;
        }
        BasePageMenu.addItem( menuItem );
        if( accountForSettingsMenu ) {
            BasePageMenu.addItem( SettingsMenuItem.get() );
            _hasSettingsMenu = true;
        }
    }
}