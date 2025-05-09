import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class HomepageMenu extends BasePageMenu {
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

    (:exclForTouch)
    private function initialize( sitemapHomepage as SitemapHomepage ) {
        BasePageMenu.initialize( 
            sitemapHomepage, 
            new Bitmap( {
                    :rezId => Rez.Drawables.menuDownToSettings,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } ) );
    }

    (:exclForButton)
    private var _settingsMenuItem as SettingsMenuItem = new SettingsMenuItem( self );    
    (:exclForButton)
    private function initialize( sitemapHomepage as SitemapHomepage ) {
        BasePageMenu.initialize( sitemapHomepage, null );
        addItem( _settingsMenuItem );
    }
    (:exclForButton)
    public function update( sitemapPage as SitemapPage ) as Boolean {
        deleteItem( getItemCount()-1 );
        var result = BasePageMenu.update( sitemapPage );
        addItem( _settingsMenuItem );
        return result;
    }

    public function onShow() as Void {
        ToastHandler.setUseToasts( true );
    }
}