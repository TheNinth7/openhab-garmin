import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

class EdgeDefaultConstants extends DefaultConstants {
    protected function initialize() { DefaultConstants.initialize(); }

    public static const UI_MENU_TITLE_HEIGHT as Number = 
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.25 ).toNumber();

    public static const UI_MENU_FOOTER_HEIGHT as Number = 
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.2 ).toNumber();

    public static const UI_MENU_TITLE_HEIGHT_FACTOR as Float = 1.0;

    public static const UI_MENU_TITLE_FONT as FontDefinition = Graphics.FONT_LARGE;  
    public static const UI_MENU_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY];
    public static const UI_MENU_ITEM_PADDING_LEFT_FACTOR as Float = 0.01;
    public static const UI_MENU_ITEM_PADDING_RIGHT_FACTOR as Float = 0.01;
    public static const UI_MENU_ITEM_STATUS_PADDING_RIGHT_FACTOR as Float = 0.0;
    public static const UI_MENU_ITEM_SPACING_FACTOR as Float = 0.05;

    public static const UI_MENU_ITEM_HEIGHT as Number = 
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.175 ).toNumber();

    public static const UI_SETTINGS_ITEM_HEIGHT as Number = 
        ( DefaultConstants.UI_SCREEN_HEIGHT * 0.25 ).toNumber();
}