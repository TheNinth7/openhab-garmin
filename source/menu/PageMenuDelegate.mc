import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class PageMenuDelegate extends WatchUi.Menu2InputDelegate {
    public function initialize() {
        Menu2InputDelegate.initialize();
    }

    public function onSelect( item as WatchUi.MenuItem ) {
        try {
            if( item instanceof PageMenuItem ) {
                ViewHandler.pushView( item.getMenu(), new PageMenuDelegate(), WatchUi.SLIDE_LEFT );
            } else if( item instanceof OnOffMenuItem ) {
                item.processStateChange();
            }
        } catch( ex ) {
            ExceptionHandler.handleException( ex );
        }
    }

    public function onBack() {
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
    }

}