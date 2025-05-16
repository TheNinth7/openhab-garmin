import Toybox.Lang;

class CustomPickable {
    private var _value as Object;
    private var _label as String;

    public function initialize( value as Object, label as String ) {
        _value = value;
        _label = label;
    }

    public function getValue() as Object {
        return _value;
    }

    public function getLabel() as String {
        return _label;
    }
}