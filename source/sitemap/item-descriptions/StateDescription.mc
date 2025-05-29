import Toybox.Lang;

/*
 * Represents a state along with its description.
 * Used to handle both widget mappings and item command descriptions.
 */

// An array of commands
typedef StateDescriptionArray as Array<StateDescription>;

class StateDescription extends BaseDescription {
    public var value as String;
    public function initialize( v as String, l as String ) {
        BaseDescription.initialize( v, l );
        value = v;
    }
}