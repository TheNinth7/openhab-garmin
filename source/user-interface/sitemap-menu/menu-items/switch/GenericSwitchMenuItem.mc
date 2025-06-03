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
    // We keep the sitemap element for all the configuration
    // but will also update the state there if it is changed by the app
    private var _sitemapSwitch as SitemapSwitch;

    // The Drawable that shows the current state
    private var _statusDrawable as StatusTextArea;

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        // This menu item applies to all Switches, that
        // have a mapping defined
        return 
            sitemapWidget instanceof SitemapSwitch 
            && sitemapWidget.hasMappings()
            && sitemapWidget.item.hasState();
    }

    // Constructor
    public function initialize( sitemapSwitch as SitemapSwitch ) {
        _sitemapSwitch = sitemapSwitch;
        
        // Initialize the Drawable for the status text, and set the color
        _statusDrawable = new StatusTextArea( 
            sitemapSwitch.label, 
            sitemapSwitch.transformedState
        );

        _statusDrawable.setColor( Constants.UI_COLOR_ACTIONABLE );
        
        // Initialize the superclass
        BaseSwitchMenuItem.initialize( sitemapSwitch, _statusDrawable, true );
    }

    // Override the update method of the super class
    // and obtain the updated list of commmand mappings
    public function update( sitemapWidget as SitemapWidget ) as Void {
        BaseSwitchMenuItem.update( sitemapWidget );
        _sitemapSwitch = sitemapWidget as SitemapSwitch;
    }

    // Called by the superclass if the state changes
    // Updates the member and Drawable
    // This is called by update() of the superclass, and thus
    // at the end of the update() function above
    // It is also called after a command was sent to immediately
    // show the new state, even before the next sitemap update
    // arrives
    public function updateItemState( state as String ) as Void {
        _sitemapSwitch.updateState( state );
        
        _statusDrawable.update( 
            _sitemapSwitch.label, 
            _sitemapSwitch.transformedState
        );
    }

    // Called by the superclass to determine the command
    // that shell be sent when the menu item is selected
    public function getNextCommand() as String? {
        var itemState = _sitemapSwitch.item.state;
        var commandDescriptions = _sitemapSwitch.commandDescriptions;
        if( commandDescriptions.size() == 1 ) {
            // For one mapping, we just send that command
            return commandDescriptions[0].command;
        } else if ( commandDescriptions.size() == 2 ) {
            // For two mappings, we check if the current state equals
            // to one of them and then send the other
            if( commandDescriptions[0].command.equals( itemState ) ) {
                return commandDescriptions[1].command;
            } else if( commandDescriptions[1].command.equals( itemState ) ) {
                return commandDescriptions[0].command;
            }
        }
        
        // For all other cases, we show the action menu
        var actionMenu = new ActionMenu( null );
        // Add items
        for( var i = 0; i < commandDescriptions.size(); i++ ) {
            var commandDescription = commandDescriptions[i];
            // We exclude the current state
            if( ! commandDescription.command.equals( itemState ) ) {
                actionMenu.addItem( new ActionMenuItem(
                    { :label => commandDescription.label },
                    commandDescription.command
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
}