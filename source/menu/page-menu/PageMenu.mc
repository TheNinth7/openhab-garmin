import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class PageMenu extends BasePageMenu {
    public function initialize( sitemapPage as SitemapPage ) {
        BasePageMenu.initialize( 
            sitemapPage, 
            new Bitmap( {
                    :rezId => Rez.Drawables.logoOpenhabText,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } ) );
    }
}