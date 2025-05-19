import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class for creating the appropriate object 
 * based on a given sitemap element.
 */
class MenuItemFactory {

    // Creates a menu item based on the sitemap element type
    public static function createMenuItem( sitemapElement as SitemapElement ) as CustomMenuItem {
        if( sitemapElement instanceof SitemapPage ) {
            return new PageMenuItem( sitemapElement );
        } else if( ! sitemapElement.isStateFresh ) {
            return new NoStateMenuItem( sitemapElement as SitemapPrimitiveElement );
        } else if( OnOffSwitchMenuItem.isMyType( sitemapElement ) ) {
            return new OnOffSwitchMenuItem( sitemapElement as SitemapSwitch );
        } else if( TextMenuItem.isMyType( sitemapElement ) ) {
            return new TextMenuItem( sitemapElement as SitemapText );
        } else if( SliderMenuItem.isMyType( sitemapElement ) ) {
            return new SliderMenuItem( sitemapElement as SitemapSlider );
        } else if( GenericSwitchMenuItem.isMyType( sitemapElement ) ) {
            return new GenericSwitchMenuItem( sitemapElement as SitemapSwitch );
         } else if( NoStateMenuItem.isMyType( sitemapElement ) ) {
            return new NoStateMenuItem( sitemapElement as SitemapPrimitiveElement );
       } else {
            throw new JsonParsingException( "Element '" + sitemapElement.label + "' is not supported" );
        }
    }
}