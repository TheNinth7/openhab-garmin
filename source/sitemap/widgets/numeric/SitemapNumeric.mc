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
        // Obtain the item part of the element
        try {
            item = new NumericItem( json.getObject( "item", "no item" ) );
        } catch( ex ) {
            // The item does not have the type/label, so we add it to any
            // exception thrown when creating the item
            throw new JsonParsingException( 
                type + " '" + label + "': " + ex.getErrorMessage() );
        }

        // The superclass relies on the item for parsing the icon, 
        // therefore we initialize it after the item was created
        SitemapWidget.initialize( json, initSitemapFresh, asyncProcessing );

        minValue = json.getNumber( "minValue", 0 );
        maxValue = json.getNumber( "maxValue", 100 );
        step = json.getNumber( "step", 1 );
        releaseOnly = json.getBoolean( "releaseOnly" );

        // For numeric we override the display state to
        // achieve consistent formatting with the full-screen
        // widgets that allow changing the number
        displayState = item.state + item.unit;
    }

    // To be used to update the state if a change
    // is triggered from within the app
    public function updateState( numericState as Number ) as Void {
        // If the state in the sitemap is the same as we got passed
        // in there is no need to update. updateState is relatively
        // costly due to the lookup of the description
        if( item.numericState != numericState ) {
            item.numericState = numericState;
            item.state = numericState.toString();
            icon = parseIcon( iconType, item );
            remoteDisplayState = Item.NO_STATE;
            displayState = item.state + item.unit;
        }
    }
}