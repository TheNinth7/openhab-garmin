import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class for creating the appropriate object 
 * based on a given sitemap element.
 */
class MenuItemFactory {

    // Creates a menu item based on the sitemap element type
    public static function createMenuItem( 
        sitemapWidget as SitemapWidget, 
        parent as BasePageMenu 
    ) as CustomMenuItem {
        if( sitemapWidget instanceof SitemapFrame ) {
            return new FrameMenuItem( sitemapWidget, parent );
        } else if( ! sitemapWidget.isSitemapFresh ) {
            // If the sitemap is not fresh, we display no state - regardless of type matching
            return new NoStateMenuItem( sitemapWidget );
        } else if( OnOffSwitchMenuItem.isMyType( sitemapWidget ) ) {
            return new OnOffSwitchMenuItem( sitemapWidget as SitemapSwitch );
        } else if( TextMenuItem.isMyType( sitemapWidget ) ) {
            return new TextMenuItem( sitemapWidget as SitemapText );
        } else if( SliderMenuItem.isMyType( sitemapWidget ) ) {
            return new SliderMenuItem( sitemapWidget as SitemapSlider );
        } else if( GenericSwitchMenuItem.isMyType( sitemapWidget ) ) {
            return new GenericSwitchMenuItem( sitemapWidget as SitemapSwitch );
         } else if( NoStateMenuItem.isMyType( sitemapWidget ) ) {
            // If none of the widgets was a match, we default to no state
            // The widgets above verify if there is a valid state, so
            // they won't trigger a match if there is none
            return new NoStateMenuItem( sitemapWidget );
       } else {
            throw new JsonParsingException( "Element '" + sitemapWidget.label + "' is not supported" );
        }
    }
}