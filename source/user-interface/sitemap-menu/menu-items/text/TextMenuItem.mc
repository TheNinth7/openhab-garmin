import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Menu item implementation for `Text` sitemap elements.
 * The text status is displayed in the status field of BaseSitemapMenuItem.
 * The status is extracted from the sitemap element's label, which contains
 * both the label text and the status enclosed in square brackets.
 * This approach is preferred over retrieving the status from the associated item,
 * as the embedded status includes any formatting defined for the sitemap text element.
 */
class TextMenuItem extends BaseSitemapMenuItem {
    
    // The text status Drawable
    private var _statusTextArea as StatusTextArea;

    // Constructor
    public function initialize( sitemapText as SitemapText ) {
        _statusTextArea = new StatusTextArea( sitemapText.label, sitemapText.transformedState );
        BaseSitemapMenuItem.initialize(
            {
                :sitemapWidget => sitemapText,
                :state => _statusTextArea
            }
        );
    }

    // Updates the menu item
    public function update( sitemapWidget as SitemapWidget ) as Void {
        BaseSitemapMenuItem.update( sitemapWidget );
        if( ! ( sitemapWidget instanceof SitemapText ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapWidget.label + "' was passed into TextMenuItem but is of a different type" );
        }
        _statusTextArea.update( sitemapWidget.label, sitemapWidget.transformedState );
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return 
            sitemapWidget instanceof SitemapText
            && sitemapWidget.hasTransformedState(); 
    }
}
