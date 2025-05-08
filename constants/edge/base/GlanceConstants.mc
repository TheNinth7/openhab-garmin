import Toybox.Lang;
import Toybox.Graphics;

/*
    GlanceConstants is only implemented once for all Edge devices
*/
(:glance)
class GlanceConstants extends GlanceDefaultConstants {
    protected function initialize() { GlanceDefaultConstants.initialize(); }
    
    // Edge devices need larger fonts
    public static const UI_GLANCE_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL];
}