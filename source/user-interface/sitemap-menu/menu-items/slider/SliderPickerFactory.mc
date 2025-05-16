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
 *
 * Although this class mainly serves as a factory, it also handles
 * command sending when 'releaseOnly' is disabled. In that mode,
 * commands are sent as the user scrolls through values.
 * Since there is no delegate function for scroll changes, the
 * Drawable request itself is used to detect when the user
 * scrolls to a new value.
 */
class SliderPickerFactory extends PickerFactory {
    // The associated menu item
    private var _menuItem as SliderMenuItem;
    
    // The list of Drawables that are shown by the Picker
    private var _drawables as Array<SliderPickerDrawable> = [];
    
    // The currently selected index
    // See getCurrentIndex() for context
    private var _currentIndex as Number = -1;
    
    // The index for which a command was sent last
    // See getDrawable() for context
    private var _lastCommandedIndex as Number = -1;

    // Constructor
    // Builds the list of drawables
    public function initialize( menuItem as SliderMenuItem ) {
        PickerFactory.initialize();

        // Store the menu item and get the
        // data we need for building the list
        _menuItem = menuItem;
        var sitemapSlider = menuItem.getSitemapSlider();
        var unit = sitemapSlider.unit;
        var currentValue = sitemapSlider.sliderState;

        // Start at minValue and increment by step
        // until the next value would exceed maxValue.
        // If maxValue is not an exact multiple of the step,
        // the final entry will be the last step below maxValue.
        for( var i = sitemapSlider.minValue; i <= sitemapSlider.maxValue; i += sitemapSlider.step ) {
            if( _currentIndex == -1 && currentValue <= i ) {
                _currentIndex = _drawables.size();
                if( i != currentValue ) {
                    _drawables.add( new SliderPickerDrawable( currentValue, unit ) );
                }
            }
            _drawables.add( new SliderPickerDrawable( i, unit ) );
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
        
        // The current state is already set, so we do not need
        // to send a command as long as we remain at that index
        _lastCommandedIndex = _currentIndex;
    }

    // Get the current index. When the picker is initialized, the
    // index of the current step is needed to preselect it when opened
    public function getCurrentIndex() as Number {
        if( _currentIndex == -1 ) {
            throw new GeneralException( "Slider picker could not calculate current index" );
        }
        return _currentIndex;
    }

    // Returns the Drawable at the specified index.
    // If 'releaseOnly' is disabled, a command is sent whenever the
    // user scrolls to a new index to update the state accordingly.
    //
    // Note: getDrawable() may be called multiple times for the same index,
    // so we track the last index that triggered a command using
    // _lastCommandIndex. A new command is sent only if the requested
    // index differs from _lastCommandIndex.
    public function getDrawable( item as Number, isSelected as Boolean ) as Drawable or Null {
        Logger.debug( "SliderPickerFactory.getDrawable: item=" + item + " isSelected=" + isSelected );
        _currentIndex = item;
        
        // Get the drawable at the current index
        var drawable = _drawables[item];
        
        // If we are not in releaseOnly mode, and
        // the index has changed since the last command,
        // then we call updateState of the menu item,
        // which will send the command.
        if( ( ! _menuItem.getSitemapSlider().releaseOnly ) 
            && ( _lastCommandedIndex != item ) ) 
        {
            _lastCommandedIndex = item;
            _menuItem.updateState( drawable.getValue() );
        }
        return drawable;
    }

    // Returns the value associated with a Drawable.
    // The Picker uses this to obtain the value passed to
    // the delegate’s onAccept() function when a selection is confirmed.
    public function getValue( item as Number ) as Object or Null {
        Logger.debug( "SliderPickerFactory.getValue: item=" + item );
        return _drawables[item].getValue();
    }

    // Returns the number of Picker elements
    public function getSize() as Number {
        return _drawables.size();
    }
}