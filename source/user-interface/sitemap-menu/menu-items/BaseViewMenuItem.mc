import Toybox.Lang;
import Toybox.WatchUi;

class BaseViewMenuItem extends BaseSitemapMenuItem {

    protected function initialize( options as BaseMenuItemOptions ) {
        BaseSitemapMenuItem.initialize( options );
    }

    public function onSelect() as Void {
        onSelectImpl();
    }

    protected function onSelectImpl() as Void {
        throw new AbstractMethodException( "BaseViewMenuItem.onSelectImpl" );
    }
}