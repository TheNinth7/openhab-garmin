import Toybox.Lang;
import Toybox.WatchUi;

class BaseViewMenuItem extends BaseSitemapMenuItem {

    // The touch implementation is experimental
    // Intention is to ensure that when returning, the selected
    // item is in focus. In the simulator this did not help,
    // but maybe it does on the real device

    // If it does not work, this whole class can be scrapped

    (:exclForButton)
    var _parentMenu as CustomMenu;

    (:exclForButton)
    protected function initialize( options as BaseMenuItemOptions ) {
        BaseSitemapMenuItem.initialize( options );
        if( options[:parentMenu] == null ) {
            throw new GeneralException( "BaseViewMenuItem needs :parentMenu option set" );
        }
        _parentMenu = options[:parentMenu] as CustomMenu;
    }

    (:exclForButton)
    public function onSelect() as Void {
        var id = getId();
        if( id == null ) {
            throw new GeneralException( "BaseViewMenuItem needs :id option set" );
        }
        var index = _parentMenu.findItemById( id as Object );
        if( index == -1 ) {
            throw new GeneralException( "BaseViewMenuItem was not added to parent menu" );
        }
        _parentMenu.setFocus( index );
        onSelectImpl();
    }

    (:exclForTouch)
    protected function initialize( options as BaseMenuItemOptions ) {
        BaseSitemapMenuItem.initialize( options );
    }

    (:exclForTouch)
    public function onSelect() as Void {
        onSelectImpl();
    }

    protected function onSelectImpl() as Void {
        throw new AbstractMethodException( "BaseViewMenuItem.onSelectImpl" );
    }
}