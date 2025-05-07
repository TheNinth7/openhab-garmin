import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class TextStatusDrawable extends TextArea {
    private const HEIGHT = ( Constants.UI_MENU_ITEM_HEIGHT * 0.8 ).toNumber();
    private var _text as String;
    private var _label as String;

    public function setAvailableWidth( availableWidth as Number ) as Void {
        var textLength = _text.length();
        setSize( availableWidth * textLength/(textLength+_label.length()), height );
    }

    public function initialize( parsedLabel as [String, String] ) {
        _label = parsedLabel[0];
        _text = parsedLabel[1];
        TextArea.initialize( {
            :text => _text,
            :color => Graphics.COLOR_LT_GRAY,
            :backgroundColor => Graphics.COLOR_BLACK,
            :font => Constants.UI_MENU_ITEM_FONTS,
            :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
            :height => HEIGHT
        } );
    }

    public function update( parsedLabel as [String, String] ) as Void {
        _label = parsedLabel[0];
        _text = parsedLabel[1];
        setText( _text );
    }
}
