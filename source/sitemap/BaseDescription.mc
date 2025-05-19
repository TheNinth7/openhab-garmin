import Toybox.Lang;

/*
 * Base class for textual descriptions identified by an ID.
 * Used for widget mappings, item commands, and state descriptions.
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

    // Checks if the ID of this instance equals a given ID
    public function equalsById( otherId as String ) as Boolean {
        return _id.equals( otherId );
    }
}