import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A menu item that displays an on/off switch as its status.
 * Selecting the item toggles the switch state.
 */
class BinarySwitchMenuItem extends StatusChangingMenuItem {
    typedef OneOrTwoCommands as CommandMapping or TwoCommands;
    typedef TwoCommands as [CommandMapping, CommandMapping];

    private var _currentState as CommandMapping;
    private var _commands as OneOrTwoCommands;

    private var _statusDrawable as TextStatusDrawable;

    public function getNextCommand() as String {
        if( _commands instanceof CommandMapping ) {
            return _commands.command;
        } else {
            var commands = _commands as TwoCommands;
            if( _currentState.equals( commands[0] ) ) {
                return commands[1].command;
            } else {
                return commands[0].command;
            }
        }
    }

    // Constructor
    public function initialize( sitemapSwitch as SitemapSwitch ) {
        _commands = simplifyCommands( sitemapSwitch.mappings );
        _currentState = getCurrentState( sitemapSwitch.normalizedItemState );
        _statusDrawable = new TextStatusDrawable( sitemapSwitch.label, _currentState.label );
        _statusDrawable.setColor( Constants.UI_COLOR_ACTIONABLE );
        StatusChangingMenuItem.initialize( sitemapSwitch, _statusDrawable );
    }

    public function update( sitemapElement as SitemapElement ) as Boolean {
        var sitemapSwitch = sitemapElement as SitemapSwitch;
        _commands = simplifyCommands( sitemapSwitch.mappings );
        return StatusChangingMenuItem.update( sitemapElement );
    }

    private function simplifyCommands( commands as Array<CommandMapping> ) as OneOrTwoCommands {
        if( commands.size() == 1 ) {
            return commands[0];
        } else if( commands.size() == 2 ) {
            return [commands[0], commands[1]];
        } else {
            throw new GeneralException( "BinarySwitchMenuItem supports only one or two commands" );
        }
    }

    private function getCurrentState( state as String ) as CommandMapping {
        if( _commands instanceof CommandMapping ) {
            return _commands;
        } else {
            var commands = _commands as TwoCommands;
            if( state.equals( commands[0].command ) ) {
                return commands[0];
            } else if( state.equals( commands[1].command ) ) {
                return commands[1];
            } else {
                throw new GeneralException( "BinarySwitchMenuItem: invalid state" );
            }
        }
    }

    // Update the member and Drawable
    public function updateItemState( state as String ) as Void {
        _currentState = getCurrentState( state );
        _statusDrawable.update( getLabel(), _currentState.label );
    }

    // Used during updates to check if a sitemap element matches this menu item type.
    // If so, the item is updated; otherwise, it is replaced.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
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
}