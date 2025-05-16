import Toybox.Lang;

class SliderPickable extends CustomPickable {
    public function initialize( value as Number, unit as String ) {
        CustomPickable.initialize( value, value.toString() + unit );
    }
}