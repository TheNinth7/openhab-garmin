import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

/*
 * `HomepageMenu` represents the root of the sitemap.
 * Since there is only one root, it is implemented as a singleton.
 *
 * It behaves similarly to a regular `PageMenu`, but includes additional 
 * functionality for accessing the settings menu.
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

    // The HomepageMenu is the entry point into the
    // menu structure, where we want to display toast notifications for
    // non-fatal errors
    public function onShow() as Void {
        ToastHandler.setUseToasts( true );
    }

    // On button-based devices, the settings icon is displayed in the footer
    (:exclForTouch)
    private function initialize( sitemapHomepage as SitemapHomepage ) {
        BasePageMenu.initialize( 
            sitemapHomepage, 
            new Bitmap( {
                    :rezId => Rez.Drawables.iconDownToSettings,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } ) );
    }

    // For touch-based devices there is a dedicated menu item for
    // showing the settings menu
    (:exclForButton)
    private var _settingsMenuItem as SettingsMenuItem = new SettingsMenuItem();    
    (:exclForButton)
    private function initialize( sitemapHomepage as SitemapHomepage ) {
        BasePageMenu.initialize( sitemapHomepage, null );
        // Add the item
        addItem( _settingsMenuItem );
    }
    // Since update() syncs the menu items with the sitemap, we need
    // to remove the settings menu item beforehand and add it again
    // afterwards
    (:exclForButton)
    public function update( sitemapPage as SitemapPage ) as Boolean {
        deleteItem( getItemCount()-1 );
        var result = BasePageMenu.update( sitemapPage );
        addItem( _settingsMenuItem );
        return result;
    }
}