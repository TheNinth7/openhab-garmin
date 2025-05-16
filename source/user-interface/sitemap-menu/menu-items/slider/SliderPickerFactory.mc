import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Factory class that provides the elements displayed by the Picker.
 * It uses the slider configuration from SitemapSlider to generate
 * a list of Drawables based on minValue, maxValue, and step.
 *
 * If the current state does not match any of the defined steps,
 * an additional Drawable is inserted at the correct position
 * between the two nearest steps to represent the current value.
 */
class SliderPickerFactory extends CustomPickerFactory {
    // The list of Drawables that are shown by the Picker
    private var _pickables as Array<CustomPickable> = [];
    
    // The currently selected index
    private var _currentIndex as Number = -1;
    private var _nonConforming as SliderPickable?;

    // Constructor
    // Builds the list of drawables
    public function initialize( menuItem as SliderMenuItem ) {
        CustomPickerFactory.initialize();

        // Get the data we need for building the list
        var sitemapSlider = menuItem.getSitemapSlider();
        var unit = sitemapSlider.unit;
        var currentValue = sitemapSlider.sliderState;

        // Start at minValue and increment by step
        // until the next value would exceed maxValue.
        // If maxValue is not an exact multiple of the step,
        // the final entry will be the last step below maxValue.
        for( var i = sitemapSlider.minValue; i <= sitemapSlider.maxValue; i += sitemapSlider.step ) {
            if( _currentIndex == -1 && currentValue <= i ) {
                _currentIndex = _pickables.size();
                if( i != currentValue ) {
                    _nonConforming = new SliderPickable( currentValue, unit );
                    _pickables.add( _nonConforming );
                }
            }
            _pickables.add( new SliderPickable( i, unit ) );
        }
        
        // This code can be enabled to add maxValue as a separate step,
        // even if it doesn't align exactly with the defined step intervals.
        // NOTE: If enabled, the loop condition above must be changed to
        // `i < sitemapSlider.maxValue` to avoid adding maxValue twice
        // when it already falls on a step boundary.
        /*
        _drawables.add( new SliderPickerDrawable( sitemapSlider.maxValue, unit ) );
        if( _currentIndex == -1 ) {
            _currentIndex = _drawables.size()-1;
        }
        */
    }

    public function getCurrent() as CustomPickable {
        return _pickables[_currentIndex];
    }

    private function consumeNonconforming() as Boolean {
        if( _nonConforming != null ) {
            _pickables.remove( _nonConforming );
            _nonConforming = null;
            return true;
        } else {
            return false;
        }
    }

    public function up() as Void {
        if( ! consumeNonconforming() ) {
            _currentIndex++;            
        }
        if( _currentIndex >= _pickables.size() ) {
            _currentIndex = 0;
        }
    }

    public function down() as Void {
        consumeNonconforming();
        _currentIndex--;
        if( _currentIndex < 0 ) {
            _currentIndex = _pickables.size() - 1;
        }
    }

}