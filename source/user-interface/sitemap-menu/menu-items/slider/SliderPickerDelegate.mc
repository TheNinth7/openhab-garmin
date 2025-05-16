import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Delegate that handles only confirm and cancel actions from the Picker.
 * Scrolling within the Picker list is handled in the getDrawable() function
 * of the SliderPickerFactory.
 */
class SliderPickerDelegate extends PickerDelegate {
    private var _menuItem as SliderMenuItem;
    private var _previousState as Number;

    // Constructor
    public function initialize( menuItem as SliderMenuItem ) {
        PickerDelegate.initialize();
        _menuItem = menuItem;
        _previousState = menuItem.getSitemapSlider().sliderState;
    }

    // If the user confirms and we ARE in releaseOnly mode,
    // then we change the state here. Otherwise we just
    // pop the Picker from the view stack.
    public function onAccept( values as Array ) as Boolean {
        var newState = values[0];

        Logger.debug( "SliderPickerDelegate.onAccept" );
        if( _menuItem.getSitemapSlider().releaseOnly ) {
            if( ! ( newState instanceof Number ) ) {
                throw new GeneralException( "SliderPickerDelegate: invalid value selected" );    
            }
            Logger.debug( "SliderPickerDelegate.onAccept: new state=" + newState.toString() );
            _menuItem.updateState( newState );
        }
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
        return true;
    }    

    // If the user confirms and we ARE NOT in releaseOnly mode,
    // then we revert the state here. Otherwise we just
    // pop the Picker from the view stack.
    public function onCancel() as Boolean {
        Logger.debug( "SliderPickerDelegate.onCancel" );
        if( ! _menuItem.getSitemapSlider().releaseOnly ) {
            if( _menuItem.getSitemapSlider().sliderState != _previousState ) {
                Logger.debug( "SliderPickerDelegate.onCancel: reverting to state=" + _previousState.toString() );
                _menuItem.updateState( _previousState );
            } else {
                Logger.debug( "SliderPickerDelegate.onCancel: state did not change" );
            }
        }
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
        return true;
    }    
}