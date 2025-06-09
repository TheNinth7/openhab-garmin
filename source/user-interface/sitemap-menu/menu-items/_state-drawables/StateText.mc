import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Drawable for displaying the state as text with a fixed font.
 * The state is printed in light grey to visually offset it from the label,
 * matching the style of an "off" state in on/off switches.
 */
class StateText extends Text {

    private const FONT as FontDefinition = Constants.UI_MENU_ITEM_FONTS[0];

    // The super class Text fills the width member
    // only after Drawing. However we need the width
    // for layout calculations, so we calculate it and store
    // it here
    public var precomputedWidth as Number;

    // Keep the text do be able to detect if value passed
    // into setText is an actual change
    private var _text as String;

    // Constructor  
    public function initialize( text as String ) {
        Text.initialize( {
            :text => text,
            :font => FONT,
            :color => Constants.UI_COLOR_ACTIONABLE,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR            
        } );
        _text = text;
        precomputedWidth = TextDimensions.getTextWidthInPixels( text, FONT );
    }

    // Updates the text state
    public function setText( text as Lang.String or Lang.ResourceId ) as Void {
        if( ! text.equals( _text ) ) {
            if( text instanceof String ) {
                _text = text;
                precomputedWidth = TextDimensions.getTextWidthInPixels( text, FONT );
                Text.setText( text );
            } else {
                throw new GeneralException( "StateText does not support ResourceIds" );
            }
        }
    }
}
