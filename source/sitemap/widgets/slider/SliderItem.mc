import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing the item associated with a `SitemapSlider`.
 *
 * The slider widget uses data from the base item, and this class
 * adds the state transformed into a numeric value. This ensures
 * that the widget implementation can rely on the state being numeric.
 */
class SliderItem extends Item {

    public var numericState as Number;

    // Constructor
    public function initialize( json as JsonAdapter ) {
        Item.initialize( json );

        var localNumericState = state.toNumber();
        if( localNumericState == null ) {
            throw new JsonParsingException( "Slider item state is not numeric" );
        }
        numericState = localNumericState;
    }
}