import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

typedef CustomPickerFactory as interface {
    function up() as Void;
    function down() as Void;
    function getCurrent() as String;
};