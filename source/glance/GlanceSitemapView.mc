import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Application.Properties;

(:glance) 
class GlanceSitemapView extends WatchUi.GlanceView {
    private var _sitemapRequest as GlanceSitemapRequest;

    public function initialize() {
        GlanceView.initialize();
        _sitemapRequest = new GlanceSitemapRequest();
    }

    public function onUpdate( dc as Dc ) as Void {
    }

    public function onHide() as Void {
        _sitemapRequest.persist();
    }

}
