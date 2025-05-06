import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class HomepageMenu extends BasePageMenu {
    (:exclForTouch)
    public function initialize( sitemapHomepage as SitemapHomepage ) {
        BasePageMenu.initialize( 
            sitemapHomepage, 
            new Bitmap( {
                    :rezId => Rez.Drawables.menuDownToSettings,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } ) );
    }

    (:exclForButton)
    private var _settingsMenuItem as SettingsMenuItem = new SettingsMenuItem();    
    (:exclForButton)
    public function initialize( sitemapHomepage as SitemapHomepage ) {
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