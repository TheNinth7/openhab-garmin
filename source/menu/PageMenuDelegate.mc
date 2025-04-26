using Toybox.WatchUi;
using Toybox.System;

class PageMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect( item as WatchUi.MenuItem ) {
        System.println( item.getId() );
    }
}