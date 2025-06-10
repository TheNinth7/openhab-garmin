import Toybox.Lang;

public class BaseDescriptions {
    public var _descriptions as Array<BaseDescription>;

    public function initialize( descriptions as Array<BaseDescription> ) {
        _descriptions = descriptions;
    }

    public function hasDescriptions() as Boolean {
        return _descriptions.size() > 0;
    }

    public function get( i as Number ) as BaseDescription {
        return _descriptions[i];
    }

    // Lookup a command/state and if found return the label
    public function lookup( state as String ) as String? {
        for( var i = 0; i < _descriptions.size(); i++ ) {
            var description = _descriptions[i];
            if( description.equalsById( state ) ) {
                return description.getLabel();
            }
        }
        return null;
    }

    public function size() as Number {
        return _descriptions.size();
    }
}