import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
    Defines constants and their default values.
    To access the constants, the class Constants shall be used.
    The default implementation of Constants just inherits the
    default values, but for some devices there are implementations
    that override some of the values.
*/
class DefaultConstants {
    protected function initialize() {}
    
    // Height of the screen, used in calculation of other constants
    public static const UI_SCREEN_HEIGHT = System.getDeviceSettings().screenHeight;

    // Height of menu title and footer
    // If set to -1, the default height will be applied
    public static const UI_MENU_TITLE_HEIGHT as Number = -1;
    public static const UI_MENU_FOOTER_HEIGHT as Number = -1;

    // This factor is applied to the title's Dc to determine the height of the
    // area actually painted in the background color. Default is that 80% of the
    // total available space is used, the remaining 20% serves as spacing towards
    // the menu items
    public static const UI_MENU_TITLE_HEIGHT_FACTOR as Float = 0.8;

    // Font to be used in the menu title
    public static const UI_MENU_TITLE_FONT as FontDefinition = Graphics.FONT_SMALL;  

    // Background color of the menu titles
    public static const UI_MENU_TITLE_BACKGROUND_COLOR as Number = 0x212021;
    
    // Item height can be set individually for sitemap menu and settings menu
    public static const UI_MENU_ITEM_HEIGHT as Number = 
        ( UI_SCREEN_HEIGHT * 0.2 ).toNumber();
    public static const UI_SETTINGS_ITEM_HEIGHT as Number = 
        ( UI_SCREEN_HEIGHT * 0.3 ).toNumber();


    // List of fonts that can be used for menu item label and text-based status
    // Depending on the available space and length of the text, a font size will be choosen
    public static const UI_MENU_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];

    // These factors determine the padding to the left and right of menu items,
    // based on the total width of the menu item Dc
    // ATTENTION: for some devices there is a discrepancy between the
    // menu item Dc width on simulator and on the real device, where it is wider
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.03;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.03;

    // Spacing between the menu item elements (icon, label, status)
    public static const UI_MENU_ITEM_STATUS_PADDING_RIGHT_FACTOR as Float = 0.03;
    public static const UI_MENU_ITEM_SPACING_FACTOR as Float = 0.03;

    // Background color of menu items. Some newer devices such as the Fenix 8
    // series provides a colored background for the focused item. Therefore
    // the background color is set to transparent to allow this focus background
    // to shine through
    public static const UI_MENU_ITEM_BG_COLOR = Graphics.COLOR_TRANSPARENT;
    
    // A different background color can be defined for the focused menu items
    // This is needed for example on the Edge 540 and 840, since those provide
    // no built-in indication of the focused item (see constants/edge/button)
    // If set to transparent then the coloring will not be applied
    public static const UI_MENU_ITEM_BG_COLOR_FOCUSED as ColorType = Graphics.COLOR_TRANSPARENT;
}