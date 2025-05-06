import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class SettingsTextMenuItem extends CustomMenuItem {

    private var _label as String;
    private var _subLabel as String;
    private var _labelTextArea as Text?;
    private var _subLabelTextArea as TextArea?;

    public function initialize( label as String, subLabel as String ) {
        CustomMenuItem.initialize( null, {} );
        _label = label;
        _subLabel = subLabel;
    }

    private function initializeDrawables( dc as Dc ) as Void {
        var dcWidth = dc.getWidth();
        var yCenter = ( dc.getHeight()/2 ).toNumber();

        var locX = ( dcWidth * AppProperties.getMenuItemLeftPaddingFactor() ).toNumber();

        _labelTextArea = new Text( {
            :text => _label,
            :font => Graphics.FONT_SMALL,
            :locX => locX,
            :locY => yCenter - Graphics.getFontHeight( Graphics.FONT_SMALL ),
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
            :color => Graphics.COLOR_WHITE,
            :backgroundColor => Graphics.COLOR_BLACK,
            :width => dcWidth,
            :height => yCenter
        } );
        _subLabelTextArea = new TextArea( {
            :text => _subLabel,
            :font => [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY],
            :locX => locX,
            :locY => yCenter,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
            :color => Graphics.COLOR_WHITE,
            :backgroundColor => Graphics.COLOR_BLACK,
            :width => dc.getWidth(),
            :height => yCenter
        } );
    }

    public function draw( dc as Dc ) as Void {
        if( _labelTextArea == null ) {
            initializeDrawables( dc );
        }
        
        ( _labelTextArea as TextArea ).draw( dc );
        ( _subLabelTextArea as TextArea ).draw( dc );
    }
}