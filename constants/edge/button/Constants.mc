import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
    Constants for button-based Edge devices
*/
class Constants extends EdgeDefaultConstants {
    protected function initialize() { EdgeDefaultConstants.initialize(); }

    // Button-based Edge devices need a colored background for the
    // focused item, since those devices to not provide any other
    // visual indication showing which item is focused
    public static const UI_MENU_ITEM_BG_COLOR_FOCUSED = 0x04395E;
}