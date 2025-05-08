import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

class DefaultConstants {
    protected function initialize() {}
    
    public static const UI_SCREEN_HEIGHT = System.getDeviceSettings().screenHeight;

    public static const UI_MENU_TITLE_BACKGROUND_COLOR as Number = 0x212021;
    
    public static const UI_MENU_TITLE_HEIGHT as Number = -1;
    public static const UI_MENU_FOOTER_HEIGHT as Number = -1;

    // This factor is applied to the title's Dc to determine the height of the
    // area actually painted in the background color. Default is that 80% of the
    // total available space is used, the remaining 20% serves as spacing towards
    // the menu items
    public static const UI_MENU_TITLE_HEIGHT_FACTOR as Float = 0.8;
    public static const UI_MENU_TITLE_FONT as FontDefinition = Graphics.FONT_SMALL;  
    public static const UI_MENU_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];

    public static const UI_MENU_ITEM_HEIGHT as Number = 
        ( UI_SCREEN_HEIGHT * 0.2 ).toNumber();

    public static const UI_SETTINGS_ITEM_HEIGHT as Number = 
        ( UI_SCREEN_HEIGHT * 0.3 ).toNumber();

    // These factors determine the padding to the left and right of menu items,
    // based on the total width of the menu item Dc
    // ATTENTION: for some devices there is a discrepancy between the
    // menu item Dc width on simulator and on the real device, where it is wider
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.03;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.03;
    // Spacing between the menu item elements (icon, label, status)
    public static const UI_MENU_ITEM_STATUS_PADDING_RIGHT_FACTOR as Float = 0.03;
    public static const UI_MENU_ITEM_SPACING_FACTOR as Float = 0.03;

    public static const UI_MENU_ITEM_BG_COLOR = Graphics.COLOR_TRANSPARENT;
    public static const UI_MENU_ITEM_SELECTED_BG_COLOR = Graphics.COLOR_TRANSPARENT;
}