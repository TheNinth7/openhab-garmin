import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class CustomBehaviorDelegate extends BehaviorDelegate {
    public function initialize() {
        BehaviorDelegate.initialize();
    }

    public function onTap( clickEvent as ClickEvent ) as Boolean {
        Logger.debug( "CustomBehaviorDelegate.onTap" );
        var currentView = WatchUi.getCurrentView()[0];
        if( currentView instanceof CustomView ) {
            var touchAreas = currentView.getTouchAreas();
            var coordinates = clickEvent.getCoordinates();
            for( var i = touchAreas.size() - 1; i >= 0; i-- ) {
                var touchArea = touchAreas[i];
                if( touchArea.contains( coordinates ) ) {
                    return onAreaTap( touchArea.getId(), clickEvent );
                }
            }
        }
        return false;
    }

    public function onAreaTap( area as Symbol, clickEvent as ClickEvent ) as Boolean {
        Logger.debug( "CustomBehaviorDelegate.onAreaTap" );
        return false;
    }
}