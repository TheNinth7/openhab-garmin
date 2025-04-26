import Toybox.Lang;
import Toybox.WatchUi;

class SwitchMenuItem extends ToggleMenuItem {

    function initialize( sitemapSwitch as SitemapSwitch ) {
        ToggleMenuItem.initialize(
            sitemapSwitch.label,
            null,
            sitemapSwitch.itemName, // identifier
            sitemapSwitch.isEnabled,
            null
        );
    }

    function update( data as JsonObject ) as Void {
    }
}