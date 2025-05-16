import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Main implementation of the Picker.
 * This subclass is necessary because the base class does not
 * clear the display context (Dc) in its onUpdate() method.
 */
class SliderPicker extends Picker {

    public function initialize( title as String, factory as SliderPickerFactory ) {
        Picker.initialize( {
            :pattern => [factory],
            :defaults => [factory.getCurrentIndex()],
            :confirm => new Bitmap( { 
                :rezId => Rez.Drawables.iconCheck
            } ),
            :title => new Text( {
                :text => title,
                :locX => WatchUi.LAYOUT_HALIGN_CENTER, 
                :locY => WatchUi.LAYOUT_VALIGN_CENTER,
                :color => Constants.UI_COLOR_TEXT,
                :backgroundColor => Constants.UI_COLOR_BACKGROUND
            } ) 
        } );
    }

    // Clear the Dc
    public function onUpdate( dc as Dc ) as Void {
        // We need to clear the clip, because there is bug in Garmin SDK,
        // with a clip in the menu title setting a clip in subsequent views
        // being displayed. See here for more details:
        // https://github.com/TheNinth7/ohg/issues/81
        dc.clearClip();

        dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_COLOR_BACKGROUND );
        dc.clear();
        Picker.onUpdate( dc );

        /*
        new Bitmap( {
            :rezId => Rez.Drawables.iconCheck
        } ).draw( dc );
        */
        /*
        new Bitmap( {
            :rezId => Rez.Drawables.logoOpenhabSquare,
            :locX => WatchUi.LAYOUT_HALIGN_LEFT,
            :locY => WatchUi.LAYOUT_HALIGN_CENTER
        } ).draw( dc );
        */
    }
}