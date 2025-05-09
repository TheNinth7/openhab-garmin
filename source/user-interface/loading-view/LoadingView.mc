import Toybox.Graphics;
import Toybox.WatchUi;

class LoadingView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    public function onShow() as Void {
        ToastHandler.setUseToasts( false );
    }

    function onUpdate( dc as Dc ) as Void {
        dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_BLACK );
        dc.clear();
        new Text( {
            :text => "Loading ...",
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        } ).draw( dc );
    }
}
