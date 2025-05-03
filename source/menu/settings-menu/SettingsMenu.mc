import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class SettingsMenu extends Menu2 {

    private var _itemCount as Number = 0;

    public function initialize() {
        Menu2.initialize( {
                :title => "Settings",
                :footer => new Bitmap( {
                    :rezId => Rez.Drawables.logoOpenhabText,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } )
            } );

        _itemCount++;
        addItem( new MenuItem(
            "App Version",
            Application.loadResource( Rez.Strings.AppVersion ) as String,
            null,
            null
        ) );

        _itemCount++;
        addItem( new MenuItem(
            "Server",
            AppSettings.getUrl(),
            null,
            null
        ) );
    }

    public function focusFirst() as Void {
        setFocus( 0 );
    }

    public function focusLast() as Void {
        setFocus( _itemCount - 1 );
    }
}