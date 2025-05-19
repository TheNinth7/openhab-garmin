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
        } else if( NoStateMenuItem.isMyType( sitemapElement ) ) {
            // No state will be displayed, if
            // the elements state is missing, NULL or UNDEF
            // or the whole state has become stale
            // The freshness/staleness of the state is only checked by
            // NoStateMenuItem, therefore it needs to come before all
            // menu items that should not show a state when the state is stale
            return new NoStateMenuItem( sitemapElement as SitemapPrimitiveElement );
        } else if( OnOffSwitchMenuItem.isMyType( sitemapElement ) ) {
            return new OnOffSwitchMenuItem( sitemapElement as SitemapSwitch );
        } else if( TextMenuItem.isMyType( sitemapElement ) ) {
            return new TextMenuItem( sitemapElement as SitemapText );
        } else if( SliderMenuItem.isMyType( sitemapElement ) ) {
            return new SliderMenuItem( sitemapElement as SitemapSlider );
        } else if( GenericSwitchMenuItem.isMyType( sitemapElement ) ) {
            return new GenericSwitchMenuItem( sitemapElement as SitemapSwitch );
        } else {
            throw new JsonParsingException( "Element '" + sitemapElement.label + "' is not supported" );
        }
    }
}