import Toybox.Lang;

/*
 * The Math class lacks a square function, we therefore implement it here.
 * This allows for example squaring a function result without having to
 * store it in a local variable.
 */
class CustomMath {
    public static function square( a as Numeric ) as Numeric {
        return a * a;
    }
}