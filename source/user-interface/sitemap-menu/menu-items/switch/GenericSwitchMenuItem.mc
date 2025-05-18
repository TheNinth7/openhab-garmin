import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A menu item that displays the current state of an item as text
 * and sends a command when selected.
 *
 * Intended for use with `Switch` sitemap elements, where possible
 * commands are defined via the element's `mappings` property.
 *
 * Behavior on selection:
 * - If only one command is defined, it is sent immediately.
 * - If two commands are defined and the current state matches one of them,
 *   the other command is sent (toggling behavior).
 * - In all other cases, an action menu is shown, allowing the user to
 *   manually select a command to send.
 */
class GenericSwitchMenuItem extends BaseSwitchMenuItem {
    // The current state and the label shown
    // for it on the screen
    private var _currentState as String;
    private var _currentStateLabel as String;
    private var _unit as String;

    // The available commands
    private var _commandMappings as CommandMappingArray;

    // The Drawable that shows the current state
    private var _statusDrawable as TextStatusDrawable;

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        // This menu item applies to all Switches, that
        // have a mapping defined
        return 
            sitemapElement instanceof SitemapSwitch 
            && 
            sitemapElement.hasMappings();
    }

    // Constructor
    public function initialize( sitemapSwitch as SitemapSwitch ) {
        _currentState = sitemapSwitch.normalizedItemState;
        _unit = sitemapSwitch.unit;
        _commandMappings = verifyCommandMappings( sitemapSwitch.mappings );
        _currentStateLabel = getStateLabel();
        
        // Initialize the Drawable for the status text, and set the color
        _statusDrawable = new TextStatusDrawable( sitemapSwitch.label, _currentStateLabel );
        _statusDrawable.setColor( Constants.UI_COLOR_ACTIONABLE );
        
        // Initialize the superclass
        BaseSwitchMenuItem.initialize( sitemapSwitch, _statusDrawable, true );
    }

    // Override the update method of the super class
    // and obtain the updated list of commmand mappings
    public function update( sitemapElement as SitemapElement ) as Boolean {
        var sitemapSwitch = sitemapElement as SitemapSwitch;
        _unit = sitemapSwitch.unit;
        _commandMappings = verifyCommandMappings( sitemapSwitch.mappings );
        return BaseSwitchMenuItem.update( sitemapElement );
    }

    // Called by the superclass if the state changes
    // Updates the member and Drawable
    // This is called by update() of the superclass, and thus
    // at the end of the update() function above
    public function updateItemState( state as String ) as Void {
        _currentState = state;
        _currentStateLabel = getStateLabel();
        _statusDrawable.update( getLabel(), _currentStateLabel );
    }

    // Called by the superclass to determine the command
    // that shell be sent when the menu item is selected
    public function getNextCommand() as String? {
        if( _commandMappings.size() == 1 ) {
            // For one mapping, we just send that command
            return _commandMappings[0].command;
        } else if ( _commandMappings.size() == 2 ) {
            // For two mappings, we check if the current state equals
            // to one of them and then send the other
            if( _currentState.equals( _commandMappings[0].command ) ) {
                return _commandMappings[1].command;
            } else if( _currentState.equals( _commandMappings[1].command ) ) {
                return _commandMappings[0].command;
            }
        }
        
        // For all other cases, we show the action menu
        var actionMenu = new ActionMenu( null );
        // Add items
        for( var i = 0; i < _commandMappings.size(); i++ ) {
            var commandMapping = _commandMappings[i];
            // We exclude the current state
            if( ! commandMapping.command.equals( _currentState ) ) {
                actionMenu.addItem( new ActionMenuItem(
                    { :label => commandMapping.label },
                    commandMapping.command
                ) );
            }
        }
        WatchUi.showActionMenu( actionMenu, new GenericSwitchActionMenuDelegate( self ) );
        // Returning null tells the super class to not
        // send any command and instead wait for the
        // action menu delegate to trigger the sending
        // of the command
        return null;
    }

    // Looks up the label for the current state
    // If the state is not found in the command mappings,
    // then the state string itself will be used as label
    private function getStateLabel() as String {
        for( var i = 0; i < _commandMappings.size(); i++ ) {
            var commandMapping = _commandMappings[i];
            if( commandMapping.command.equals( _currentState ) ) {
                return commandMapping.label;
            }
        }
        return renderState( _currentState, _unit );
    }

    // Verifies that there is at least one mapping,
    // otherwise throws an exception
    private function verifyCommandMappings( mappings as CommandMappingArray )as CommandMappingArray {
        if( mappings.size() == 0 ) {
            throw new GeneralException( "GenericSwitchMenuItem needs at one command" );
        }
        return mappings;
    }

}