import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Singleton class that provides two BufferedBitmaps representing
 * a toggle switch in the "on" and "off" positions.
 *
 * `OnOffStatusDrawable` provides the standard-sized version,
 * while this class offers a smaller version intended for use 
 * alongside a submenu indicator.
 */
class SmallOnOffStatusBitmaps extends OnOffStatusBitmaps {
    
    // Singleton accessor
    private static var _instance as SmallOnOffStatusBitmaps?;
    public static function get() as SmallOnOffStatusBitmaps {
        if( _instance == null ) {
            _instance = new SmallOnOffStatusBitmaps();
        }
        return _instance as SmallOnOffStatusBitmaps;
    }

    // When combined with a sub-menu indicator, the toggle switch will be rendered smaller 
    // The factors below are 0.65 the factor of the standard sized icon
    public var HEIGHT as Number = ( Constants.UI_MENU_ITEM_HEIGHT * 0.52 ).toNumber(); // Factor 0.8 * 0.65
    public var WIDTH as Number = ( Constants.UI_MENU_ITEM_HEIGHT * 0.2925 ).toNumber(); // Factor 0.45 * 0.65

    // Constructor
    private function initialize() {
        OnOffStatusBitmaps.initialize();
    }
}