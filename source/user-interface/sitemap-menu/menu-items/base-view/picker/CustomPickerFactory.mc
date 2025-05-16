import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class CustomPickerFactory {
    function up() as Void {
        throw new AbstractMethodException( "CustomPickerFactory.up" );
    }
    function down() as Void {
        throw new AbstractMethodException( "CustomPickerFactory.down" );
    }
    function getCurrent() as CustomPickable {
        throw new AbstractMethodException( "CustomPickerFactory.up" );
    }
}
