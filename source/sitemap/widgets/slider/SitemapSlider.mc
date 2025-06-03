import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Slider` elements.
 */

class SitemapSlider extends SitemapWidget {

    // The item associated with the widget
    public var item as SliderItem;

    // Slider properties
    public var minValue as Number;
    public var maxValue as Number;
    public var step as Number;
    public var releaseOnly as Boolean;
 
    public function initialize( 
        json as JsonAdapter, 
        isStateFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapWidget.initialize( json, isSitemapFresh, asyncProcessing );

        // Obtain the item part of the element
        item = new SliderItem( json.getObject( "item", "Slider '" + label + "' has no item" ) );

        minValue = json.getNumber( "minValue", 0 );
        maxValue = json.getNumber( "maxValue", 100 );
        step = json.getNumber( "step", 1 );
        releaseOnly = json.getBoolean( "releaseOnly" );
    }
}