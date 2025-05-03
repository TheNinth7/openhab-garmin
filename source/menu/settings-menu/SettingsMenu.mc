import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class SettingsMenu extends CustomMenu {

    private var _itemCount as Number = 0;

    public static var ITEM_HEIGHT as Number = 
        ( System.getDeviceSettings().screenHeight * 0.3 ).toNumber();

    public function initialize() {
        CustomMenu.initialize( 
            ITEM_HEIGHT,
            Graphics.COLOR_BLACK, 
            {
                :title => new Text( {
                    :text => "Settings",
                    :color => Graphics.COLOR_WHITE,
                    :font => Graphics.FONT_SMALL,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } ),
                :footer => new Bitmap( {
                    :rezId => Rez.Drawables.logoOpenhabText,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } )
            } );

        _itemCount++;
        addItem( new SettingsTextMenuItem(
            "App Version",
            Application.loadResource( Rez.Strings.AppVersion ) as String
        ) );

        _itemCount++;
        addItem( new SettingsTextMenuItem(
            "Server",
            AppSettings.getUrl()
        ) );
    }

    public function focusFirst() as Void {
        setFocus( 0 );
    }

    public function focusLast() as Void {
        setFocus( _itemCount - 1 );
    }
}