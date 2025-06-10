import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Setpoint` and `Slider` elements.
 */

class SitemapNumeric extends SitemapWidget {

    private var _numericDisplayState as String;

    private var _numericItem as NumericItem;

    // Setpoint/Slider properties
    private var _minValue as Number;
    private var _maxValue as Number;
    private var _step as Number;
    private var _releaseOnly as Boolean; // Slider only
 
    // Constructor
    public function initialize( 
        json as JsonAdapter, 
        isSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        // Obtain the item part of the element
        try {
            _numericItem = new NumericItem( json.getObject( "item", "no item" ) );
        } catch( ex ) {
            // The item does not have the type/label, so we add it to any
            // exception thrown when creating the item
            throw new JsonParsingException( 
                getType() + " '" + getLabel() + "': " + ex.getErrorMessage() );
        }

        // The superclass relies on the item for parsing the icon, 
        // therefore we initialize it after the item was created
        SitemapWidget.initialize( 
            json, 
            _numericItem, 
            null, 
            isSitemapFresh, 
            asyncProcessing 
        );

        _minValue = json.getNumber( "minValue", 0 );
        _maxValue = json.getNumber( "maxValue", 100 );
        _step = json.getNumber( "step", 1 );
        _releaseOnly = json.getBoolean( "releaseOnly" );

        // For numeric sitemap widgets we override the display state to
        // achieve consistent formatting with the full-screen
        // widgets that allow changing the number
        _numericDisplayState = _numericItem.getState() + _numericItem.getUnit();
    }

    // Display state for numeric items is build from
    // the item state and item unit
    public function getDisplayState() as String { return _numericDisplayState; }

    // Returns the numeric item subclass
    public function getNumericItem() as NumericItem { return _numericItem; }

    // Setpoint/Slider properties
    public function getMinValue() as Number { return _minValue; }
    public function getMaxValue() as Number { return _maxValue; }
    public function getStep() as Number { return _step; }

    // If there is a state, there will always be a display state
    public function hasDisplayState() as Boolean {
        return _numericItem.hasState();
    }

    // Slider property
    public function isReleaseOnly() as Boolean { return _releaseOnly; }

    // To be used to update the state if a change
    // is triggered from within the app
    public function updateState( numericState as Number ) as Void {
        // If the state in the sitemap is the same as we got passed
        // in there is no need to update.
        if( _numericItem.getNumericState() != numericState ) {
            _numericItem.updateNumericState( numericState );
            processUpdatedState();
        }
    }
}