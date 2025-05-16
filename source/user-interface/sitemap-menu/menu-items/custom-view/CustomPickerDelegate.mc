import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class CustomPickerDelegate extends CustomBehaviorDelegate {
    public function initialize() {
        CustomBehaviorDelegate.initialize();
    }

    public function onAreaTap( area as Symbol, clickEvent as ClickEvent ) as Boolean {
        Logger.debug( "CustomPickerDelegate.onAreaTap" );
        if( area == :touchUp ) {
            Logger.debug( "CustomPickerDelegate.onAreaTap: touchUp" );
        } else if( area == :touchDown ) {
            Logger.debug( "CustomPickerDelegate.onAreaTap: touchDown" );
        } else if( area == :touchCheck ) {
            Logger.debug( "CustomPickerDelegate.onAreaTap: touchCheck" );
        } else if( area == :touchCancel ) {
            Logger.debug( "CustomPickerDelegate.onAreaTap: touchCancel" );
        }
        return false;
    }
}