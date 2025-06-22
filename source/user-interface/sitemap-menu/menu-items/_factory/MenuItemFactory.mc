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
        processingMode as BasePageMenu.ProcessingMode
    ) as BaseWidgetMenuItem {
        
        // Check if there is still sufficent memory, otherwise
        // ensureMemory() will throw an exception
        MemoryManager.ensureMemory();

        if( ContainerMenuItem.isMyType( sitemapWidget ) ) {
            return new ContainerMenuItem( 
                sitemapWidget as SitemapFrame or SitemapGroup, 
                parent,
                processingMode );
        } else if( ! sitemapWidget.isSitemapFresh() ) {
            // If the sitemap is not fresh, we display no state - regardless of type matching
            return new NoStateMenuItem( sitemapWidget, parent, processingMode );
        } else if( OnOffSwitchMenuItem.isMyType( sitemapWidget ) ) {
            return new OnOffSwitchMenuItem( sitemapWidget as SitemapSwitch, parent, processingMode );
        } else if( TextMenuItem.isMyType( sitemapWidget ) ) {
            return new TextMenuItem( sitemapWidget as SitemapText, parent, processingMode );
        } else if( NumericMenuItem.isMyType( sitemapWidget ) ) {
            return new NumericMenuItem( sitemapWidget as SitemapNumeric, parent, processingMode );
        } else if( RollershutterMenuItem.isMyType( sitemapWidget ) ) {
            return new RollershutterMenuItem( sitemapWidget as SitemapSwitch, parent, processingMode );
        } else if( GenericSwitchMenuItem.isMyType( sitemapWidget ) ) {
            return new GenericSwitchMenuItem( sitemapWidget as SitemapSwitch, parent, processingMode );
        } else if( NoStateMenuItem.isMyType( sitemapWidget ) ) {
            // If none of the widgets was a match, we default to no state
            // The widgets above verify if there is a valid state, so
            // they won't trigger a match if there is none
            return new NoStateMenuItem( sitemapWidget, parent, processingMode );
       } else {
            throw new JsonParsingException( "Element '" + sitemapWidget.getLabel() + "' is not supported" );
        }
    }
}