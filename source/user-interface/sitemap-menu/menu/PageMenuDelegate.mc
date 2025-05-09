import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class PageMenuDelegate extends WatchUi.Menu2InputDelegate {
    
    // Needs to be public despite this being a singleton class,
    // due to a Monkey C quirk:
    // With protected, the static get() cannot access it
    // With private, the derived HomepageMenuDelegate cannot access
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    private static var _instance as PageMenuDelegate?;
    public static function get() as PageMenuDelegate {
        if( _instance == null ) {
            _instance = new PageMenuDelegate();
        }
        return _instance as PageMenuDelegate;
    }
    
    public function onSelect( item as WatchUi.MenuItem ) as Void {
        // Logger.debug( "PageMenuDelegate: onSelect" );
        try {
            ( item as BaseSitemapMenuItem ).onSelect();
        } catch( ex ) {
            // Logger.debug( "PageMenuDelegate: exception" );
            ExceptionHandler.handleException( ex );
        }
    }

    public function onBack() as Void {
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
    }

}