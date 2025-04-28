import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class PageMenuDelegate extends WatchUi.Menu2InputDelegate {
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect( item as WatchUi.MenuItem ) {
        System.println( "PageMenuDelegate: onSelect" );
        try {
            ( item as BaseMenuItem ).onSelect();
        } catch( ex ) {
            System.println( "PageMenuDelegate: exception" );
            ExceptionHandler.handleException( ex );
        }
    }

    public function onBack() {
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
    }

}