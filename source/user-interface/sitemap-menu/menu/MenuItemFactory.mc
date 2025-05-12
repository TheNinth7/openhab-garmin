import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class for creating the appropriate object 
 * based on a given sitemap element.
 */
class MenuItemFactory {

    // Creates a menu item based on the sitemap element type
    public static function createMenuItem( sitemapElement as SitemapElement ) as CustomMenuItem {
        if( OnOffMenuItem.isMyType( sitemapElement ) ) {
            return new OnOffMenuItem( sitemapElement as SitemapSwitch );
        } else if( TextMenuItem.isMyType( sitemapElement ) ) {
            return new TextMenuItem( sitemapElement as SitemapText );
        } else if( sitemapElement instanceof SitemapPage ) {
            return new PageMenuItem( sitemapElement );
        } else if( NoStateMenuItem.isMyType( sitemapElement ) ) {
            return new NoStateMenuItem( sitemapElement as SitemapPrimitiveElement );
        } else {
            throw new JsonParsingException( "Element '" + sitemapElement.label + "' is not supported" );
        }
    }
}