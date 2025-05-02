import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class SystemInfoView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate( dc as Dc ) as Void {
        dc.clear();
        var text = "ohg " + Application.loadResource( Rez.Strings.AppVersion ) as String + 
                   "\nerror count=" + SitemapErrorCountStore.get();
        new TextArea( {
            :text => text,
            :color => Graphics.COLOR_WHITE,
            :backgroundColor => Graphics.COLOR_BLACK,
            :font => [ Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY ],
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        } ).draw( dc );
    }
}
