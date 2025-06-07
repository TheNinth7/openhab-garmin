import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing the item associated with a `SitemapNumeric`.
 *
 * The Numeric widget uses data from the base item, and this class
 * adds the state transformed into a numeric value. This ensures
 * that the widget implementation can rely on the state being numeric.
 */
class NumericItem extends Item {

    public var numericState as Number = 0;

    // Constructor
    public function initialize( json as JsonAdapter ) {
        Item.initialize( json );

        // If there is no state, we leave the numeric
        // state at 0, analogue to how the 
        // openHAB Main UI handles it
        if( hasState() ) {
            var localNumericState = state.toNumber();
            if( localNumericState != null ) {
                numericState = localNumericState;
            } else {
                throw new JsonParsingException( "state is not numeric" );
            }
        }
    }
}