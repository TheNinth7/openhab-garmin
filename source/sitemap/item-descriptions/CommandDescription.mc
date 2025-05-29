import Toybox.Lang;

/*
 * Represents a command along with its description.
 * Used to handle both widget mappings and item command descriptions.
 */

// An array of commands
typedef CommandDescriptionArray as Array<CommandDescription>;

class CommandDescription extends BaseDescription {
    public var command as String;
    public function initialize( c as String, l as String ) {
        BaseDescription.initialize( c, l );
        command = c;
    }
}