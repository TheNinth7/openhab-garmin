import Toybox.Lang;

/*
 * The default `GlanceConstants` implementation inherits all base values 
 * without overriding any defaults.
 */
class Constants extends DefaultConstants {
    protected function initialize() { DefaultConstants.initialize(); }
}