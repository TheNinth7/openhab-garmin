import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Setpoint` and `Slider` elements.
 */

class SitemapNumeric extends SitemapWidget {

    // The item associated with the widget
    public var item as NumericItem;

    // Setpoint/Slider properties
    public var minValue as Number;
    public var maxValue as Number;
    public var step as Number;
    public var releaseOnly as Boolean; // Slider only
 
    public function initialize( 
        json as JsonAdapter, 
        initSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapWidget.initialize( json, initSitemapFresh, asyncProcessing );

        // Obtain the item part of the element
        try {
            item = new NumericItem( json.getObject( "item", "no item" ) );
        } catch( ex ) {
            // The item does not have the type/label, so we add it to any
            // exception thrown when creating the item
            throw new JsonParsingException( 
                type + " '" + label + "': " + ex.getErrorMessage() );
        }

        minValue = json.getNumber( "minValue", 0 );
        maxValue = json.getNumber( "maxValue", 100 );
        step = json.getNumber( "step", 1 );
        releaseOnly = json.getBoolean( "releaseOnly" );
    }
}