import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class PageMenuDelegate extends WatchUi.Menu2InputDelegate {
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect( item as WatchUi.MenuItem ) as Void {
        // Logger.debug( "PageMenuDelegate: onSelect" );
        try {
            ( item as BaseMenuItem ).onSelect();
        } catch( ex ) {
            // Logger.debug( "PageMenuDelegate: exception" );
            ExceptionHandler.handleException( ex );
        }
    }

    public function onBack() as Void {
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
    }

}