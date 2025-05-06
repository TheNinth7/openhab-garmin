import Toybox.Lang;
import Toybox.Application.Properties;

class AppProperties {
    private static var _instance as AppProperties?;
    
    private static function getInstance() as AppProperties {
        if( _instance == null ) {
            _instance = new AppProperties();
        }
        return _instance as AppProperties;
    }

    public var menuTitleBackgroundColor as Number;
    public var menuItemLeftPaddingFactor as Number;
    
    private function initialize() {
        menuTitleBackgroundColor = Properties.getValue( "menuTitleBackgroundColor" ) as Number;
        menuItemLeftPaddingFactor = Properties.getValue( "menuItemLeftPaddingFactor" ) as Number;
    }

    public static function getMenuTitleBackgroundColor() as Number { return getInstance().menuTitleBackgroundColor; }
    public static function getMenuItemLeftPaddingFactor() as Number { return getInstance().menuItemLeftPaddingFactor; }
}