import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class BaseSitemapMenuItem extends BaseMenuItem {

    protected function initialize( options as BaseMenuItemOptions ) {
        BaseMenuItem.initialize( options );
    }

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean { 
        throw new AbstractMethodException( "BaseSitemapMenuItem.getItemType" );
    }
    public function update( sitemapElement as SitemapElement ) as Boolean { 
        throw new AbstractMethodException( "BaseSitemapMenuItem.update" );
    }
}