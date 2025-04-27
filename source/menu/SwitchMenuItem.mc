import Toybox.Lang;
import Toybox.WatchUi;

class SwitchMenuItem extends ToggleMenuItem {

    function initialize( sitemapSwitch as SitemapSwitch ) {
        ToggleMenuItem.initialize(
            sitemapSwitch.label,
            null,
            sitemapSwitch.id, // identifier
            sitemapSwitch.isEnabled,
            null
        );
    }

    function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return sitemapElement instanceof SitemapSwitch;
    }

    function update( sitemapSwitch as SitemapSwitch ) as Boolean {
        setLabel( sitemapSwitch.label );
        setEnabled( sitemapSwitch.isEnabled );
        return true;
    }
}