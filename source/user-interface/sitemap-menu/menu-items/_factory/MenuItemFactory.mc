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
        parent as BasePageMenu,
        taskQueue as TaskQueue
    ) as BaseWidgetMenuItem {
        MemoryManager.ensureMemory();
        if( ContainerMenuItem.isMyType( sitemapWidget ) ) {
            return new ContainerMenuItem( 
                sitemapWidget as SitemapFrame or SitemapGroup, 
                parent,
                taskQueue );
        } else if( ! sitemapWidget.isSitemapFresh() ) {
            // If the sitemap is not fresh, we display no state - regardless of type matching
            return new NoStateMenuItem( sitemapWidget, parent, taskQueue );
        } else if( OnOffSwitchMenuItem.isMyType( sitemapWidget ) ) {
            return new OnOffSwitchMenuItem( sitemapWidget as SitemapSwitch, parent, taskQueue );
        } else if( TextMenuItem.isMyType( sitemapWidget ) ) {
            return new TextMenuItem( sitemapWidget as SitemapText, parent, taskQueue );
        } else if( NumericMenuItem.isMyType( sitemapWidget ) ) {
            return new NumericMenuItem( sitemapWidget as SitemapNumeric, parent, taskQueue );
        } else if( RollershutterMenuItem.isMyType( sitemapWidget ) ) {
            return new RollershutterMenuItem( sitemapWidget as SitemapSwitch, parent, taskQueue );
        } else if( GenericSwitchMenuItem.isMyType( sitemapWidget ) ) {
            return new GenericSwitchMenuItem( sitemapWidget as SitemapSwitch, parent, taskQueue );
        } else if( NoStateMenuItem.isMyType( sitemapWidget ) ) {
            // If none of the widgets was a match, we default to no state
            // The widgets above verify if there is a valid state, so
            // they won't trigger a match if there is none
            return new NoStateMenuItem( sitemapWidget, parent, taskQueue );
       } else {
            throw new JsonParsingException( "Element '" + sitemapWidget.getLabel() + "' is not supported" );
        }
    }
}