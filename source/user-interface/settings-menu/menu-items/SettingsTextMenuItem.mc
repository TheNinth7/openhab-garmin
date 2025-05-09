import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
    A custom menu item for showing a text label and
    below that a sublabel
*/
class SettingsTextMenuItem extends BaseMenuItem {

    // The values and Drawables
    private var _label as String;
    private var _subLabel as String;
    private var _labelTextArea as Text?;
    private var _subLabelTextArea as TextArea?;

    // Constructor
    // Initializes the super class and
    // stores the label/sublabel
    public function initialize( label as String, subLabel as String ) {
        BaseMenuItem.initialize( { :id => label } );
        _label = label;
        _subLabel = subLabel;
    }

    // This event handler is called by the super class
    // and should draw the content
    public function drawImpl( dc as Dc ) as Void {
        // Drawables can only be initialized here
        // since we need the Dc dimensions for it
        if( _labelTextArea == null ) {
            initializeDrawables( dc );
        }
        // Draw the Drawables        
        ( _labelTextArea as TextArea ).draw( dc );
        ( _subLabelTextArea as TextArea ).draw( dc );
    }

    // Create the Drawables
    private function initializeDrawables( dc as Dc ) as Void {
        var dcWidth = dc.getWidth();
        var yCenter = ( dc.getHeight()/2 ).toNumber();

        // Apply the left padding
        var locX = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_LEFT_FACTOR ).toNumber();
        // Apply the right padding
        var width = dcWidth - locX - ( dcWidth * Constants.UI_MENU_ITEM_PADDING_RIGHT_FACTOR ).toNumber();

        // Create the Drawables
        // locY for label is set for the text to be on top of the center line,
        //      using the font height
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
}