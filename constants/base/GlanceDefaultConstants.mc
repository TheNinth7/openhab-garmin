import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

/*
    Defines glance constants and their default values.
    To access the constants, the class GlanceConstants shall be used.
    The default implementation of GlanceConstants just inherits the
    default values, but for some devices there are implementations
    that override some of the values.
*/
(:glance)
class GlanceDefaultConstants {
    protected function initialize() {}
    
    // The fonts available for the glance
    public static const UI_GLANCE_FONTS as Array<FontDefinition> = [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE];
}