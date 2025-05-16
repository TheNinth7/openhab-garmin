import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A Drawable that represents one selectable item in the Picker list.
 */
class SliderPickerDrawable extends Text {

    // The picker stores the state it represents
    private var _state as Number;

    public function initialize( state as Number, unit as String ) {
        _state = state;
        Text.initialize( {
            :text => state.toString() + unit,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER, 
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :color => Constants.UI_COLOR_TEXT,
            :backgroundColor => Constants.UI_COLOR_BACKGROUND
        } );
    }

    // Returns the state represented by this element
    public function getValue() as Number {
        return _state;
    }

    // Renders the Drawable.
    // This method is overridden because the Picker does not clear the Dc,
    // so we handle clearing it here before drawing.
    public function draw( dc as Dc ) as Void {
        dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_COLOR_BACKGROUND );
        dc.clear();
        Text.draw( dc );
    }
}

