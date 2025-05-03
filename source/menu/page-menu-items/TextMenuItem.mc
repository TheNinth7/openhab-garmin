import Toybox.Lang;
import Toybox.WatchUi;

class TextMenuItem extends BaseMenuItem {
    private var _statusTextArea as TextStatusDrawable;

    public function initialize( sitemapText as SitemapText ) {
        var parsedLabel = parseLabel( sitemapText.label );
        _statusTextArea = new TextStatusDrawable( parsedLabel );
        BaseMenuItem.initialize(
            sitemapText,
            {
                :label => parsedLabel[0],
                :status => _statusTextArea
            }
        );
    }

    public function update( sitemapElement as SitemapElement ) as Boolean {
        var parsedLabel = parseLabel( sitemapElement.label );
        _statusTextArea.update( parsedLabel );
        setCustomLabel( parsedLabel[0] );
        return true;
    }

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

    private function parserException( label as String ) as Void {
        throw new GeneralException( "Could not parse text element with label '" + label + "'" );
    }

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return sitemapElement instanceof SitemapText; 
    }
}
