import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing the item associated with a `SitemapNumeric`.
 *
 * The Numeric widget uses data from the base item, and this class
 * adds the state display into a numeric value. This ensures
 * that the widget implementation can rely on the state being numeric.
 */
class NumericItem extends Item {

    private var _numericState as Number = 0;

    // Constructor
    public function initialize( json as JsonAdapter ) {
        Item.initialize( json );

        // If there is no state, we leave the numeric
        // state at 0, analogue to how the 
        // openHAB Main UI handles it
        if( hasState() ) {
            var numericState = getState().toNumber();
            if( numericState != null ) {
                _numericState = numericState;
            } else {
                throw new JsonParsingException( "state is not numeric" );
            }
        }
    }

    // Returns the numeric state
    public function getNumericState() as Number { return _numericState; }

    // Updates the numeric state as well as the
    // string state of the base class
    public function updateNumericState( numericState as Number ) as Void {
        _numericState = numericState;
        updateState( numericState.toString() );
    }
}