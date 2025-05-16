import Toybox.Lang;
import Toybox.WatchUi;

class SliderPickerDelegate extends CustomPickerDelegate {
    private var _menuItem as SliderMenuItem;
    private var _previousState as Number;

    // Constructor
    public function initialize( menuItem as SliderMenuItem ) {
        CustomPickerDelegate.initialize();
        _menuItem = menuItem;
        _previousState = menuItem.getSitemapSlider().sliderState;
    }

    // If the user confirms and we ARE in releaseOnly mode,
    // then we change the state here. Otherwise we just
    // pop the Picker from the view stack.
    public function onAccept( newState as Object ) as Boolean {
        Logger.debug( "SliderDelegate.onAccept" );
        if( _menuItem.getSitemapSlider().releaseOnly ) {
            if( ! ( newState instanceof Number ) ) {
                throw new GeneralException( "SliderDelegate: invalid value selected" );    
            }
            Logger.debug( "SliderDelegate.onAccept: new state=" + newState.toString() );
            _menuItem.updateState( newState );
        }
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
        return true;
    }    

    // If the user cancels and we ARE NOT in releaseOnly mode,
    // then we revert the state here. Otherwise we just
    // pop the Picker from the view stack.
    public function onCancel() as Boolean {
        Logger.debug( "SliderDelegate.onCancel" );
        if( ! _menuItem.getSitemapSlider().releaseOnly ) {
            if( _menuItem.getSitemapSlider().sliderState != _previousState ) {
                Logger.debug( "SliderDelegate.onCancel: reverting to state=" + _previousState.toString() );
                _menuItem.updateState( _previousState );
            } else {
                Logger.debug( "SliderDelegate.onCancel: state did not change" );
            }
        }
        ViewHandler.popView( WatchUi.SLIDE_RIGHT );
        return true;
    }

    public function onUp( value as Object ) as Boolean {
        updateState( value );
        return true;
    }

    public function onDown( value as Object ) as Boolean {
        updateState( value );
        return true;
    }

    public function updateState( state as Object ) as Void {
        Logger.debug( "SliderDelegate.updateState=" + state );
        if( ! ( state instanceof Number ) ) {
            throw new GeneralException( "SliderDelegate: invalid state type" );
        }
        if( ! _menuItem.getSitemapSlider().releaseOnly ) {
            _menuItem.updateState( state );
        }
    }     
}