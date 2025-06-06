import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing the item associated with a `SitemapSwitch`.
 *
 * Switch is the only item type that requires both command and state descriptions.
 * If present, these are used to determine the available commands and to display
 * the current state. See `SwitchItem.transformState` for details.
 */
class SwitchItem extends Item {

    // Strings representing the on/off state
    public static const ITEM_STATE_ON = "ON";
    public static const ITEM_STATE_OFF = "OFF";

    // Strings representing the states of a rollershutter item
    public static const ITEM_STATE_UP = "UP";
    public static const ITEM_STATE_DOWN = "DOWN";
    public static const ITEM_STATE_STOP = "STOP";

    public var commandDescriptions as CommandDescriptionArray?;
    public var stateDescriptions as StateDescriptionArray?;

    // Constructor
    public function initialize( json as JsonAdapter ) {
        Item.initialize( json );

        // Then we read the item's command descriptions, if there are any
        var localCommandDescriptions = json.getOptionalObject( "commandDescription" );
        if( localCommandDescriptions != null ) {
            commandDescriptions = 
                readCommandDescriptions( 
                    localCommandDescriptions.getOptionalArray( "commandOptions" ) 
                );
        }

        var localStateDescriptions = json.getOptionalObject( "stateDescription" );
        if( localStateDescriptions != null ) {
            stateDescriptions = 
                readStateDescriptions( 
                    localStateDescriptions.getOptionalArray( "options" ) 
                );
        }

    }

    // Used for reading both the widget's mapping and
    // the items command descriptions
    public static function readCommandDescriptions( jsonCommandDescriptions as JsonAdapterArray? ) as CommandDescriptionArray {
        var commandDescriptions = new CommandDescriptionArray[0];
        if( jsonCommandDescriptions != null ) {
            for( var i = 0; i < jsonCommandDescriptions.size(); i++ ) {
                var jsonCommandDescription = jsonCommandDescriptions[i];
                commandDescriptions.add( 
                    new CommandDescription( 
                        jsonCommandDescription.getString( "command", "Switch: command is missing from mapping/command description" ),
                        jsonCommandDescription.getOptionalString( "label" )
                    )
                );
            }
        }
        return commandDescriptions;
    }

    // Used for reading the items state descriptions
    private static function readStateDescriptions( jsonStateDescriptions as JsonAdapterArray? ) as StateDescriptionArray {
        var stateDescriptions = new StateDescriptionArray[0];
        if( jsonStateDescriptions != null ) {
            for( var i = 0; i < jsonStateDescriptions.size(); i++ ) {
                var jsonStateDescription = jsonStateDescriptions[i];
                stateDescriptions.add( 
                    new StateDescription( 
                        jsonStateDescription.getString( "value", "Switch: value is missing from state description" ),
                        jsonStateDescription.getString( "label", "Switch: label is missing from state description" )
                ) );
            }
        }
        return stateDescriptions;
    }
}