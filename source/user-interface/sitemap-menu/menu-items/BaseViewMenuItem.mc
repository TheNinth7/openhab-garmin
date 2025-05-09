import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Base class for all menu items that open another view when selected.
 *
 * Currently used by `PageMenuItem` and `SettingsMenuItem`.
 * While it currently provides no shared functionality, this may change in the future.
 */
class BaseViewMenuItem extends BaseSitemapMenuItem {

    protected function initialize( options as BaseMenuItemOptions ) {
        BaseSitemapMenuItem.initialize( options );
    }

    // Any common onSelect behavior could go here
    public function onSelect() as Void {
        onSelectImpl();
    }

    // Subclasses must implement this function to implement
    // their individual onSelect behavior
    protected function onSelectImpl() as Void {
        throw new AbstractMethodException( "BaseViewMenuItem.onSelectImpl" );
    }
}