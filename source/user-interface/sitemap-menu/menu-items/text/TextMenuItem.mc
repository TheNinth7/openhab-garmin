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
    private var _statusTextArea as TextStatusDrawable;

    // Constructor
    public function initialize( sitemapText as SitemapText ) {
        _statusTextArea = new TextStatusDrawable( sitemapText.label, sitemapText.widgetState );
        BaseSitemapMenuItem.initialize(
            {
                :id => sitemapText.id,
                :label => sitemapText.label,
                :status => _statusTextArea
            }
        );
    }

    // Updates the menu item
    public function update( sitemapElement as SitemapElement ) as Boolean {
        if( ! ( sitemapElement instanceof SitemapText ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapElement.label + "' was passed into TextMenuItem but is of a different type" );
        }
        _statusTextArea.update( sitemapElement.label, sitemapElement.widgetState );
        setCustomLabel( sitemapElement.label );
        return true;
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return 
            sitemapElement instanceof SitemapText
            && sitemapElement.hasWidgetState(); 
    }
}
