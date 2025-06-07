import Toybox.Lang;

/*
 * A CustomPickable implementation that combines a value and a unit
 * into a single display label.
 */
class NumericPickable extends CustomPickable {
    public function initialize( value as Number, unit as String ) {
        CustomPickable.initialize( value, value.toString() + unit );
    }
}