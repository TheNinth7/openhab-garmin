import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * A custom menu item that displays a primary text label 
 * with a secondary sublabel beneath it.
 */
class SettingsTextMenuItem extends BaseMenuItem {

    // The values and Drawables
    private var _title as String;
    private var _subLabel as String;
    private var _labelTextArea as Text?;
    private var _subLabelTextArea as TextArea?;

    /*
    * Constructor.
    * Initializes the superclass and stores the label and sublabel.
    */
    public function initialize( label as String, subLabel as String ) {
        BaseMenuItem.initialize();
        _title = label;
        _subLabel = subLabel;
    }

    // Create the Drawables
    public function onLayout( dc as Dc ) as Void {
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
            :text => _title,
            :font => Constants.UI_MENU_ITEM_FONTS[0],
            :locX => locX,
            :locY => yCenter - Graphics.getFontHeight( Constants.UI_MENU_ITEM_FONTS[0] ),
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
            :color => Constants.UI_COLOR_TEXT,
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
            :color => Constants.UI_COLOR_TEXT,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
            :width => width,
            :height => yCenter
        } );
    }

    /*
    * Called by the superclass to handle drawing.
    * This event handler is responsible for rendering the content.
    */
    public function onUpdate( dc as Dc ) as Void {
        // Draw the Drawables        
        ( _labelTextArea as TextArea ).draw( dc );
        ( _subLabelTextArea as TextArea ).draw( dc );
    }
}