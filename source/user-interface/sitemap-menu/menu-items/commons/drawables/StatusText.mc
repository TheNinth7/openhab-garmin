import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Drawable for displaying the status as text with a fixed font.
 * The status is printed in light grey to visually offset it from the label,
 * matching the style of an "off" state in on/off switches.
 */
class StatusText extends Text {

    public var precomputedWidth as Number;
    private const FONT as FontDefinition = Constants.UI_MENU_ITEM_FONTS[0];

    // Constructor  
    public function initialize( text as String ) {
        Text.initialize( {
            :text => text,
            :font => FONT,
            :color => Constants.UI_COLOR_ACTIONABLE,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR            
        } );
        precomputedWidth = TextDimensions.getTextWidthInPixels( text, FONT );
    }

    // Updates the text status
    public function setText( text as Lang.String or Lang.ResourceId ) as Void {
        if( text instanceof String ) {
            Text.setText( text );
            precomputedWidth = TextDimensions.getTextWidthInPixels( text, FONT );
        } else {
            throw new GeneralException( "StatusText does not support ResourceIds" );
        }
    }
}
