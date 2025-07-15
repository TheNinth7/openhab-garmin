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
        taskQueue as TaskQueue
    ) {
        // Obtain the item part of the element
        try {
            _numericItem = new NumericItem( 
                json.getObject( "item", "Item not found. Check if the name is correct." ),
                isSitemapFresh 
            );
        } catch( ex ) {
            // The item does not have the type/label, so we add it to any
            // exception thrown when creating the item. To be able to
            // access the type/label, we need to initialize the base class
            SitemapWidget.initialize( json, null, null, isSitemapFresh, taskQueue );
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
            taskQueue
        );

        var hasState = _numericItem.hasState();

        _minValue = json.getNumber( "minValue", 0 );
        _maxValue = json.getNumber( "maxValue", 100 );
        _step = json.getNumber( "step", 1 );
        
        // If there is no state, the releaseOnly mode makes more
        // sense, since without release only, a known state is required
        // for cancelling, and also in WLAN mode, it does not make
        // sense to send a command for every step in the number picker
        // Therefore without state, we enable it even if the parameter was not set
        _releaseOnly = 
            hasState
            ? json.getBoolean( "releaseOnly" )
            : true;

        // For numeric sitemap widgets we override the display state to
        // achieve consistent formatting with the full-screen
        // widgets that allow changing the number
        _numericDisplayState = 
            hasState
            ? _numericItem.getState() + _numericItem.getUnit()
            : NO_DISPLAY_STATE;
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
            // Without a state, we always operate in release only
            // mode. See constructor for details.
            if( ! _numericItem.hasState() ) {
                _releaseOnly = true;
            }
        }
    }
}