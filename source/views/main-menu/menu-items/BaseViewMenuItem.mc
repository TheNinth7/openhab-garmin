import Toybox.Lang;
import Toybox.WatchUi;

class BaseViewMenuItem extends BaseSitemapMenuItem {

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
        System.println( "******** focus set to " + index );
        //_parentMenu.setFocus( index );
    }

    (:exclForTouch)
    protected function initialize( options as BaseMenuItemOptions ) {
        BaseSitemapMenuItem.initialize( options );
    }

    (:exclForTouch)
    public function onSelect() as Void {}
}