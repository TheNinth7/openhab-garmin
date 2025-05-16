import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class CustomPickerDelegate extends CustomBehaviorDelegate {
    public function initialize() {
        CustomBehaviorDelegate.initialize();
    }

    private function getCurrentValue() as Object {
        return getFactory().getCurrent().getValue();
    }

    public function onKey( keyEvent as KeyEvent ) as Boolean {
        var key = keyEvent.getKey();
        if( key == KEY_ENTER ) {
            return onAccept( getCurrentValue() );
        } else if( key == KEY_UP ) {
            return onUpInternal();
        } else if( key == KEY_DOWN ) {
            return onDownInternal();
        }
        return false;
    }

    public function onBack() as Boolean {
        return onCancel();
    }

    public function onAreaTap( area as Symbol, clickEvent as ClickEvent ) as Boolean {
        Logger.debug( "CustomPickerDelegate.onAreaTap" );
        if( area == :touchUp ) {
            return onUpInternal();
        } else if( area == :touchDown ) {
            return onDownInternal();
        } else if( area == :touchCheck ) {
            return onAccept( getCurrentValue() );
        } else if( area == :touchCancel ) {
            return onCancel();
        }
        return false;
    }

    private var _factory as CustomPickerFactory?;
    private function getFactory() as CustomPickerFactory {
        if( _factory == null ) {
            var view = WatchUi.getCurrentView()[0];
            if( view instanceof CustomPicker ) {
                _factory = view.getFactory();
            } else {
                throw new GeneralException( "CustomPickerDelegate must be used with CustomPicker view" );
            }
        }
        return _factory as CustomPickerFactory;
    }
    private function onUpInternal() as Boolean {
        getFactory().up();
        onUp( getCurrentValue() );
        WatchUi.requestUpdate();
        return false;
    }
    private function onDownInternal() as Boolean {
        getFactory().down();
        onDown( getCurrentValue() );
        WatchUi.requestUpdate();
        return false;
    }

    public function onUp( value as Object ) as Boolean {
        return false;
    }
    public function onDown( value as Object ) as Boolean {
        return false;
    }
    public function onAccept( value as Object ) as Boolean {
        return false;
    }
    public function onCancel() as Boolean {
        return false;
    }
}