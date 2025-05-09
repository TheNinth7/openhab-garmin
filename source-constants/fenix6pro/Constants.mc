import Toybox.Lang;

/*
    Constants for Fenix 6 Pro series
*/
class Constants extends DefaultConstants {
    protected function initialize() { DefaultConstants.initialize(); }
    
    // Fenix 6 Pro does not have the vertical bar on the left side
    // of the menu, and therefore need more padding to visually
    // balance the left side with the right side (which has 6% as default)
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.06;
}