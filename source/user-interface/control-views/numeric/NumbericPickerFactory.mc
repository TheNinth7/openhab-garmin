import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class that provides the elements displayed by the CustomPicker.
 * It uses the Setpoint/Slider configuration from SitemapNumeric to generate
 * a list of Drawables based on minValue, maxValue, and step.
 *
 * If the current state does not match any of the defined steps,
 * an additional Drawable is inserted at the correct position
 * between the two nearest steps to represent the current value. 
 * Once the user scrolls away from the additional Drawable, it will be removed.
 */
class NumericPickerFactory extends CustomPickerFactory {
    // The list of Drawables that are shown by the Picker
    private var _pickables as Array<CustomPickable> = [];
    
    // The currently selected index
    private var _currentIndex as Number = -1;
    // Stores an additional Drawable if needed to represent
    // a current state that doesn't conform to the widgets's parameters.
    private var _nonConforming as NumericPickable?;

    // Constructor
    // Builds the list of drawables
    public function initialize( menuItem as NumericMenuItem ) {
        CustomPickerFactory.initialize();

        // Get the data we need for building the list
        var sitemapNumeric = menuItem.getSitemapNumeric();
        var numericItem = sitemapNumeric.getNumericItem();

        var unit = numericItem.getUnit();
        var currentValue = numericItem.getNumericState();

        // Start at minValue and increment by step
        // until the next value would exceed maxValue.
        // If maxValue is not an exact multiple of the step,
        // the final entry will be the last step below maxValue.
        var maxValue = sitemapNumeric.getMaxValue();
        var step = sitemapNumeric.getStep();
        for( var i = sitemapNumeric.getMinValue(); i <= maxValue; i += step ) {
            if( _currentIndex == -1 && currentValue <= i ) {
                _currentIndex = _pickables.size();
                if( i != currentValue ) {
                    _nonConforming = new NumericPickable( currentValue, unit );
                    _pickables.add( _nonConforming );
                }
            }
            _pickables.add( new NumericPickable( i, unit ) );
        }
        
        // This code can be enabled to add maxValue as a separate step,
        // even if it doesn't align exactly with the defined step intervals.
        // NOTE: If enabled, the loop condition above must be changed to
        // `i < maxValue` to avoid adding maxValue twice
        // when it already falls on a step boundary.
        /*
        _drawables.add( new SliderPickerDrawable( maxValue, unit ) );
        if( _currentIndex == -1 ) {
            _currentIndex = _drawables.size()-1;
        }
        */
    }

    // Implementation of the functions used by CustomPicker
    public function getCurrent() as CustomPickable {
        return _pickables[_currentIndex];
    }

    // If up() was selected and we were on the non-conforming
    // Pickable, we do not need to increase the index
    // because removing the non-conforming Pickable will
    // automatically move the higher value to the current position.
    public function up() as Void {
        if( ! consumeNonconforming() ) {
            _currentIndex++;            
        }
        if( _currentIndex >= _pickables.size() ) {
            _currentIndex = 0;
        }
    }

    // When moving down, we decrease even if we were on the
    // non-conforming value
    public function down() as Void {
        consumeNonconforming();
        _currentIndex--;
        if( _currentIndex < 0 ) {
            _currentIndex = _pickables.size() - 1;
        }
    }

    // Checks if we are still on the non-conforming
    // Pickable, and if yes removes it and return true,
    // otherwise false
    private function consumeNonconforming() as Boolean {
        if( _nonConforming != null ) {
            _pickables.remove( _nonConforming );
            _nonConforming = null;
            return true;
        } else {
            return false;
        }
    }
}