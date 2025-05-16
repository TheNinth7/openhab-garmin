import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Slider` elements.
 */

class SitemapSlider extends SitemapPrimitiveElement {
    // Slider properties from the JSON
    public var minValue as Number;
    public var maxValue as Number;
    public var step as Number;
    public var releaseOnly as Boolean;
    public var sliderState as Number;
    public var unit as String = "";

    public function initialize( data as JsonObject ) {
        SitemapPrimitiveElement.initialize( data );
        minValue = getNumber( data, "minValue", 0 );
        maxValue = getNumber( data, "maxValue", 100 );
        step = getNumber( data, "step", 1 );
        releaseOnly = getBoolean( data, "releaseOnly" );
        var cv = normalizedItemState.toNumber();
        if( cv == null ) {
            throw new JsonParsingException( "Slider item state is not numeric" );
        }
        sliderState = cv;
        if( normalizedItemType.equals( "Dimmer" ) ) {
            unit = "%";
        }
    }
}