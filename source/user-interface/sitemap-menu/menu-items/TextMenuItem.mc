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
        var parsedLabel = parseLabel( sitemapText.label );
        _statusTextArea = new TextStatusDrawable( parsedLabel );
        BaseSitemapMenuItem.initialize(
            {
                :id => sitemapText.id,
                :label => parsedLabel[0],
                :status => _statusTextArea
            }
        );
    }

    // Updates the menu item
    public function update( sitemapElement as SitemapElement ) as Boolean {
        var parsedLabel = parseLabel( sitemapElement.label );
        _statusTextArea.update( parsedLabel );
        setCustomLabel( parsedLabel[0] );
        return true;
    }

    // Extracts and returns the label and status from a sitemap Text element's label.
    public function parseLabel( label as String ) as [String, String] {
        var bracket = label.find( " [" ) as Number?;
        if( bracket == null ) {
            parserException( label );
        }
        bracket = (bracket as Number);
        var customLabel = label.substring( null, bracket ) as String?;
        var itemState = label.substring( bracket+2, label.length()-1 ) as String?;
        if( customLabel == null || itemState == null ) {
            parserException( label );
        }
        return [customLabel as String, itemState as String];
    }

    // Helper function throwing an error if parsing fails
    private function parserException( label as String ) as Void {
        throw new GeneralException( "Could not parse text element with label '" + label + "'" );
    }

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return sitemapElement instanceof SitemapText; 
    }
}
