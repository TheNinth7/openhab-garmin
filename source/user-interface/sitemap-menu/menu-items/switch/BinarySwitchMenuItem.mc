import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A menu item that displays the state of an item as text,
 * and sends a command when selected.
 *
 * This is used for the `Switch` sitemap element, where the possible
 * commands must be defined in the element's `mappings` property.
 *
 * This menu item supports only:
 * - Items with one or two commands defined in `mappings`
 * - If two commands are present, the current item state must match
 *   one of them (so we can infer the other command to send next)
 *
 * For all other cases (e.g. more than two commands or ambiguous state),
 * use `MultiSwitchMenuItem` instead.
 */
class BinarySwitchMenuItem extends StatusChangingMenuItem {
    // Types used in this class
    typedef OneOrTwoCommands as CommandMapping or TwoCommands;
    typedef TwoCommands as [CommandMapping, CommandMapping];

    // The current state
    private var _currentState as CommandMapping;
    // And the available commands
    // Note: if it is only one, than _currentState will match _commandMappings
    private var _commandMappings as OneOrTwoCommands;

    // The Drawable that shows the current state
    private var _statusDrawable as TextStatusDrawable;

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        // Conditions:
        // - The sitemap element must be a Switch
        // - It must have either:
        //   - One command, or
        //   - Two commands, with the current state matching one of them
        return 
            sitemapElement instanceof SitemapSwitch 
            && 
            ( 
                sitemapElement.mappings.size() == 1
                || 
                (
                    sitemapElement.mappings.size() == 2
                    &&
                    (
                        sitemapElement.mappings[0].command == sitemapElement.normalizedItemState
                        ||
                        sitemapElement.mappings[1].command == sitemapElement.normalizedItemState
                    )                    
                )            
            );
    }

    // Constructor
    public function initialize( sitemapSwitch as SitemapSwitch ) {
        // Fill the commands
        _commandMappings = simplifyCommands( sitemapSwitch.mappings );
        
        // Get the currently command object (=mapping) that matches
        // the current state of the item
        _currentState = getCurrentState( sitemapSwitch.normalizedItemState );
        
        // Initialize the Drawable for the status text, and set the color
        _statusDrawable = new TextStatusDrawable( sitemapSwitch.label, _currentState.label );
        _statusDrawable.setColor( Constants.UI_COLOR_ACTIONABLE );
        
        // Initialize the superclass
        StatusChangingMenuItem.initialize( sitemapSwitch, _statusDrawable );
    }

    // Override the update method of the super class
    // and obtain the updated list of commmands (=mappings)
    public function update( sitemapElement as SitemapElement ) as Boolean {
        var sitemapSwitch = sitemapElement as SitemapSwitch;
        _commandMappings = simplifyCommands( sitemapSwitch.mappings );
        return StatusChangingMenuItem.update( sitemapElement );
    }

    // Called by the superclass if the state changes
    // Updates the member and Drawable
    public function updateItemState( state as String ) as Void {
        _currentState = getCurrentState( state );
        _statusDrawable.update( getLabel(), _currentState.label );
    }

    // Takes an array of commands (=mappings) and extracts either
    // the single command or a tuple of commands if it is two
    private function simplifyCommands( commands as Array<CommandMapping> ) as OneOrTwoCommands {
        if( commands.size() == 1 ) {
            return commands[0];
        } else if( commands.size() == 2 ) {
            return [commands[0], commands[1]];
        } else {
            throw new GeneralException( "BinarySwitchMenuItem supports only one or two commands" );
        }
    }

    // On a state change, looks up the currently active command mapping,
    // based on the state
    private function getCurrentState( state as String ) as CommandMapping {
        if( _commandMappings instanceof CommandMapping ) {
            return _commandMappings;
        } else {
            var commandMappings = _commandMappings as TwoCommands;
            if( state.equals( commandMappings[0].command ) ) {
                return commandMappings[0];
            } else if( state.equals( commandMappings[1].command ) ) {
                return commandMappings[1];
            } else {
                throw new GeneralException( "BinarySwitchMenuItem: invalid state" );
            }
        }
    }

    // Called by the superclass to determine the command
    // that shell be sent when the menu item is selected
    public function getNextCommand() as String {
        if( _commandMappings instanceof CommandMapping ) {
            return _commandMappings.command;
        } else {
            var commandMappings = _commandMappings as TwoCommands;
            if( _currentState.equals( commandMappings[0] ) ) {
                return commandMappings[1].command;
            } else {
                return commandMappings[0].command;
            }
        }
    }
}