import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing the item associated with a `SitemapSwitch`.
 *
 * Switch is the only item type that requires both command and state descriptions.
 * If present, these are used to determine the available commands and to display
 * the current state. See `SwitchItem.updateDisplayState` for details.
 */
class SwitchItem extends Item {

    // Strings representing the on/off state
    public static const ITEM_STATE_ON = "ON";
    public static const ITEM_STATE_OFF = "OFF";

    // Strings representing the states of a rollershutter item
    public static const ITEM_STATE_UP = "UP";
    public static const ITEM_STATE_DOWN = "DOWN";
    public static const ITEM_STATE_STOP = "STOP";

    // Strings representing the open/closed states
    public static const ITEM_STATE_OPEN = "OPEN";
    public static const ITEM_STATE_CLOSED = "CLOSED";

    private var _commandDescriptions as CommandDescriptions?;
    private var _stateDescriptions as StateDescriptions?;

    // Constructor
    public function initialize( json as JsonAdapter ) {
        Item.initialize( json );

        // Then we read the item's command descriptions, if there are any ...
        var jsonCommandDescriptions = json.getOptionalObject( "commandDescription" );
        if( jsonCommandDescriptions != null ) {
            _commandDescriptions = new CommandDescriptions( 
                jsonCommandDescriptions.getOptionalArray( "commandOptions" ) 
            );
        }

        // ... and do the same for the state descriptions
        var jsonStateDescriptions = json.getOptionalObject( "stateDescription" );
        if( jsonStateDescriptions != null ) {
            _stateDescriptions = new StateDescriptions ( 
                    jsonStateDescriptions.getOptionalArray( "options" ) 
                );
        }
    }

    public function getCommandDescriptions() as CommandDescriptions? {
        return _commandDescriptions;
    }

    public function getStateDescriptions() as StateDescriptions? {
        return _stateDescriptions;
    }

    public function lookupCommandDescription( command as String ) as String? {
        if( _commandDescriptions != null ) {
            return _commandDescriptions.lookup( command );
        } else {
            return null;
        }
    }

    public function lookupStateDescription( state as String ) as String? {
        if( _stateDescriptions != null ) {
            return _stateDescriptions.lookup( state );
        } else {
            return null;
        }
    }
}