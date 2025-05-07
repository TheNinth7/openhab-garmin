import Toybox.Lang;
import Toybox.Graphics;

(:glance)
class GlanceConstants extends GlanceDefaultConstants {
    protected function initialize() { GlanceDefaultConstants.initialize(); }
    public static const UI_GLANCE_ITEM_FONTS as Array<FontDefinition> = [Graphics.FONT_LARGE, Graphics.FONT_MEDIUM, Graphics.FONT_SMALL];
}