import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class CustomPicker extends CustomView {

    private var _title as String;
    private var _titleDrawable as TextArea?;
    private var _factory as CustomPickerFactory;
    private var _pickable as Text?;

    public function initialize( title as String, factory as CustomPickerFactory ) {
        CustomView.initialize();
        _title = title;
        _factory = factory;
    }

    public function getFactory() as CustomPickerFactory {
        return _factory;
    }

    
    public function onLayout( dc as Dc ) as Void {
        Logger.debug(( "CustomPicker.onLayout" ) );
        dc.clearClip();

        var dcHeight = dc.getHeight();
        var dcWidth = dc.getWidth();

        _titleDrawable = new TextArea( {
            :text => _title,
            :font => [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY],
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => dcHeight * 0.075,
            :width => dcWidth * 0.5,
            :height => dcHeight * 0.2
        } );
        addDrawable( _titleDrawable );

        var yStart = 0.375;
        var xSpace = 0.15;
        _pickable = new CustomText( {
            :text => "100%",
            :font => Graphics.FONT_LARGE,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => yStart + 0.25
        } );
        addDrawable( _pickable );

        addTouchArea( 
            new RectangularTouchArea( 
                :touchUp, 
                0, 
                0, 
                dcWidth, 
                ( dcHeight*(yStart+0.25) ).toNumber()
        ) );
        addTouchArea( 
            new RectangularTouchArea( 
                :touchDown, 
                0, 
                ( dcHeight*(yStart+0.25) ).toNumber(), 
                dcWidth, 
                dcHeight
        ) );

        addDrawable( new CustomBitmap( {
            :rezId => Rez.Drawables.iconUp,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => yStart
        } ) );
        addDrawable( new CustomBitmap( {
            :rezId => Rez.Drawables.iconDown,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => yStart + 0.5
        } ) );

        addDrawable( new CustomBitmap( {
            :rezId => Rez.Drawables.iconCancel,
            :locX => xSpace,
            :locY => yStart + 0.25,
            :touchId => :touchCancel
        } ) );
        addDrawable( new CustomBitmap( {
            :rezId => Rez.Drawables.iconCheck,
            :locX => 1 - xSpace,
            :locY => yStart + 0.25,
            :touchId => :touchCheck
        } ) );
    }

    public function onUpdate( dc as Dc ) as Void {
        if( _pickable != null ) {
            _pickable.setText( _factory.getCurrent().getLabel() );
        }
        CustomView.onUpdate( dc );
    }
}