import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
 * Defines application constants and their default values.
 *
 * Access these values via the `Constants` class.
 * The base `Constants` implementation provides the defaults,
 * while device-specific subclasses can override particular values.
 */
class DefaultConstants {
    protected function initialize() {}
    
    // Height of the screen, used in calculation of other constants
    public static const UI_SCREEN_HEIGHT = System.getDeviceSettings().screenHeight;

    // Height of menu title and footer
    // If set to -1, the default height will be applied
    public static const UI_MENU_TITLE_HEIGHT as Number = -1;
    public static const UI_MENU_FOOTER_HEIGHT as Number = -1;

    /*
    * Factor determining the height of the background-painted region 
    * in the title's drawing context (`Dc`). By default, 80% of the 
    * available title area is filled, leaving 20% as spacing above 
    * the menu items.
    */
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


    // List of fonts available for menu item labels and status text.
    // An appropriate font size is chosen based on available space and text length.
    public static const UI_MENU_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];

    /*
    * These factors determine the left and right padding of menu items 
    * based on the total width of the menu item's `Dc`.
    *
    * Note: On some devices, the `Dc` width differs between the simulator and 
    * the actual hardware, where it appears wider.
    */
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.03;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.03;

    // Spacing between the menu item elements (icon, label, status)
    public static const UI_MENU_ITEM_STATUS_PADDING_RIGHT_FACTOR as Float = 0.03;
    public static const UI_MENU_ITEM_SPACING_FACTOR as Float = 0.03;

    /*
    * Background color of menu items. Some newer devices, such as the Fenix 8 series,
    * provide a colored background for the focused item. Therefore, the menu item
    * background color is set to transparent to allow the focus background to show through.
    */
    public static const UI_MENU_ITEM_BG_COLOR = Graphics.COLOR_TRANSPARENT;
    
    /*
    * Allows specifying a distinct background color for focused menu items.
    * This is useful on devices like the Edge 540 and 840, which provide no built-in
    * focus indicator (see constants/edge/button). Setting this to transparent
    * disables the custom focus background.
    */
    public static const UI_MENU_ITEM_BG_COLOR_FOCUSED as ColorType = Graphics.COLOR_TRANSPARENT;

    // List of fonts to be used by the error view
    public static const UI_ERROR_FONTS as Array<FontDefinition> = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY];
}