import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class SettingsTextMenuItem extends BaseMenuItem {

    private var _label as String;
    private var _subLabel as String;
    private var _labelTextArea as Text?;
    private var _subLabelTextArea as TextArea?;

    public function initialize( label as String, subLabel as String ) {
        BaseMenuItem.initialize( { :id => label } );
        _label = label;
        _subLabel = subLabel;
    }

    private function initializeDrawables( dc as Dc ) as Void {
        var dcWidth = dc.getWidth();
        var yCenter = ( dc.getHeight()/2 ).toNumber();

        var locX = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_LEFT_FACTOR ).toNumber();
        var width = dcWidth - locX - ( dcWidth * Constants.UI_MENU_ITEM_PADDING_RIGHT_FACTOR ).toNumber();

        _labelTextArea = new Text( {
            :text => _label,
            :font => Constants.UI_MENU_ITEM_FONTS[0],
            :locX => locX,
            :locY => yCenter - Graphics.getFontHeight( Constants.UI_MENU_ITEM_FONTS[0] ),
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
            :color => Graphics.COLOR_WHITE,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
            :width => width,
            :height => yCenter
        } );
        _subLabelTextArea = new TextArea( {
            :text => _subLabel,
            :font => Constants.UI_MENU_ITEM_FONTS,
            :locX => locX,
            :locY => yCenter,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
            :color => Graphics.COLOR_WHITE,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
            :width => width,
            :height => yCenter
        } );
    }

    public function drawImpl( dc as Dc ) as Void {
        if( _labelTextArea == null ) {
            initializeDrawables( dc );
        }
        
        ( _labelTextArea as TextArea ).draw( dc );
        ( _subLabelTextArea as TextArea ).draw( dc );
    }
}