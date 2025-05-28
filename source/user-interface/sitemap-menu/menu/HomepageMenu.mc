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
    // Accessor for the Singleton instance
    private static var _instance as HomepageMenu?;
    public static function exists() as Boolean {
        return _instance != null;
    }
    public static function create( sitemapHomepage as SitemapHomepage ) as HomepageMenu {
        if( _instance == null ) {
            _instance = new HomepageMenu( sitemapHomepage );
        }
        return _instance as HomepageMenu;
    }
    public static function get() as HomepageMenu {
        if( _instance == null ) {
            throw new GeneralException( "HomepageMenu: call create() before get()" );
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
                homepageMenu = HomepageMenu.create( sitemapHomepage );
            }
        } catch( ex ) {
            Logger.debugException( ex );
        }
        return homepageMenu;
    }

    // The HomepageMenu is the entry point into the
    // menu structure, where we want to display toast notifications for
    // non-fatal errors
    public function onShow() as Void {
        ToastHandler.setUseToasts( true );
    }

    // See BasePageMenu.invalidateStructure for details
    private var _structureRemainsValid as Boolean = true;
    public function invalidateStructure() as Void {
        _structureRemainsValid = false;
    }
    public function structureRemainsValid() as Boolean {
        return _structureRemainsValid;
    }

    // Before an update we reset the indicator showing whether
    // the update left the structure intact.
    // Then we call the update function of the base class
    public function update( sitemapPage as SitemapPage ) as Void {
        _structureRemainsValid = true;
        BasePageMenu.update( sitemapPage );
    }

    // On button-based devices, the settings icon is displayed in the footer
    (:exclForTouch)
    private function initialize( sitemapHomepage as SitemapHomepage ) {
        BasePageMenu.initialize( 
            sitemapHomepage, 
            new Bitmap( {
                    :rezId => Rez.Drawables.iconDownToSettings,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } )
        );
    }

    // For touch-based devices there is a dedicated menu item for
    // showing the settings menu
    // This member tracks whether the settings menu has been added
    (:exclForButton)
    private var _hasSettingsMenu as Boolean = false;
    (:exclForButton)
    private function initialize( sitemapHomepage as SitemapHomepage ) {
        BasePageMenu.initialize( sitemapHomepage, null );
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