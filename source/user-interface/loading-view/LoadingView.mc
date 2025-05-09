import Toybox.Graphics;
import Toybox.WatchUi;

/*
    A simple full-screen view showing "Loading ..."
    This is shown when the widget starts and there is no sitemap
    in storage, so basically only when the app is started the first
    time after installation, version update or settings change
*/
class LoadingView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // When in the LoadingView all errors should immediately
    // go into a full-screen error, there is no point in 
    // showing a toast
    public function onShow() as Void {
        ToastHandler.setUseToasts( false );
    }

    // Display the loading message 
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
