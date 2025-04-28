import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class TestCustomMenuItem extends CustomMenuItem {

    public function initialize() {
        CustomMenuItem.initialize( null, {} );
    }

    public function draw( dc as Dc ) as Void {
        dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_BLACK );
        dc.clear();
        dc.drawRectangle( 0, 0, dc.getWidth(), dc.getHeight() );
        dc.drawText( dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_MEDIUM, "HUHU", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER );
    }

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return true;
    }

    public function update( sitemapSwitch as SitemapSwitch ) as Boolean {
        return true;
    }

}