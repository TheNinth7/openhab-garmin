import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Represents an openHAB item and its current state.
 *
 * For efficiency, this class includes only the item properties common to all types.
 * Subclasses, such as `SwitchItem`, add properties specific to their respective types.
 */
class Item {

    //! Name of the item.
    public var name as String;

    //! Type of the item. 
    //! If the item type is Group, then this value is set to the groupType.
    public var type as String;

    //! State of the item.
    //! If the state NULL or UNDEF it is set to null, which is displayed as em dash by the widgets.
    public var state as String?;

    //! Unit of the item.
    //! The unit is set to "%" for Dimmer and Rollershutter items, and otherwise filled from the unit provided with the JSON, if available. If neither applies it is an empty string ("").
    public var unit as String;

    //! Determine whether the item has a valid state
    //! @return true if the state is not NULL or UNDEF
    public function hasState() as Boolean {
        return state != null;
    }

    //! Constructor
    //! @param json The JSON object from which this Item should be built.
    protected function initialize( json as JsonAdapter ) {
        name =  json.getString( "name", "Item name is missing" );

        // If the item is a Group, we apply the groupType
        type =  json.getString( "type", "Item '" + name + "' has no type" );
        if( type.equals( "Group" ) ) {
            type =  json.getString( "groupType", "Item '" + name + "': group has no type" );
        }

        // If no state is available, it will be set to null
        state = json.getOptionalString( "state" );
        if( state.equals( "" )
            || state.equals( "NULL" ) 
            || state.equals( "UNDEF" ) ) 
            {
            state = null;
        }

        // For dimmer and rollershutter we always use "%",
        // regardless of the JSON. For all other types we
        // use the unit from the JSON if present
        if( type.equals( "Dimmer" ) ) {
            unit = "%";
        } else if( type.equals( "Rollershutter" ) ) {
            unit = "%";
        } else {
            unit = json.getOptionalString( "unit" );
        }
    }
}