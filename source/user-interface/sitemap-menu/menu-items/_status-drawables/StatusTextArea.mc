import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Drawable for displaying the status text in a flexible text area,
 * that chooses the font size depending on the size of the content.
 * The status is printed in light grey to visually offset it from the label,
 * matching the style of an "off" state in on/off switches.
 */
class StatusTextArea extends TextArea {
    // Analogue to the switch, we use 80% of the available height
    private const HEIGHT = ( Constants.UI_MENU_ITEM_HEIGHT * 0.8 ).toNumber();

    private var _text as String;
    private var _label as String;

    // Called by BaseSitemapMenuItem to provide the total available width for the menu item.
    // Sets the size of the status drawable proportionally based on the relative lengths 
    // of the status text and the label.
    public function setAvailableWidth( availableWidth as Number ) as Void {
        setSize( ( availableWidth * TextDimensions.getWidthRatio( _text, _label ) ).toNumber(), height );
    }

    // Constructor  
    // Stores the label for later use in size calculation (see setAvailableWidth).  
    // Initializes the text area with all properties except size, which is set separately.
    public function initialize( label as String, text as String ) {
        _label = label;
        _text = text;
        TextArea.initialize( {
            :text => _text,
            :color => Constants.UI_COLOR_INACTIVE,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
            :font => Constants.UI_MENU_ITEM_FONTS,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
            :height => HEIGHT
        } );
    }

    // Updates the text status
    public function update( label as String, text as String ) as Void {
        _label = label;
        _text = text;
        setText( _text );
    }
}
