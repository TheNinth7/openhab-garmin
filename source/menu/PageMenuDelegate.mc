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
            if( item instanceof PageMenuItem ) {
                System.println( "PageMenuDelegate: opening page" );
                ViewHandler.pushView( item.getMenu(), new PageMenuDelegate(), WatchUi.SLIDE_LEFT );
            } else if( item instanceof OnOffMenuItem ) {
                System.println( "PageMenuDelegate: processing on/off" );
                item.processStateChange();
            }
        } catch( ex ) {
            System.println( "PageMenuDelegate: exception" );
            ExceptionHandler.handleException( ex );
        }
    }

    public function onBack() {
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
    }

}