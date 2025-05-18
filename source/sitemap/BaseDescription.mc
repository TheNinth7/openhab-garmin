import Toybox.Lang;

/*
 * Represents a description identified by an id
 */

 // An array of descriptions
typedef BaseDescriptionArray as Array<BaseDescription>;

class BaseDescription {
    private var _id as String;
    public var label as String;
    protected function initialize( id as String, l as String ) {
        _id = id;
        label = l;
    }
    public function equals( other as Object or Null ) as Boolean {
        if( other instanceof String ) {
            return _id.equals( other );
        } else {
            return Object.equals( other );
        }
    }
}