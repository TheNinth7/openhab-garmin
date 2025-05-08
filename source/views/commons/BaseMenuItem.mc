import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

typedef BaseMenuItemOptions as {
    :id as Object,
    :icon as ResourceId?,
    :label as String,
    :labelColor as ColorType?,
    :status as Drawable?,
    :parentMenu as CustomMenu?
};

class BaseMenuItem extends CustomMenuItem {

    private var _icon as Drawable?;
    private var _label as String;
    private var _labelColor as ColorType;
    private var _labelTextArea as TextArea?;
    private var _status as Drawable?;
    public function getLabel() as String {
        return _label;
    }

    protected function initialize( options as BaseMenuItemOptions ) {
        CustomMenuItem.initialize( options[:id] as String, {} );

        if( options[:icon] != null ) {
            _icon = new Bitmap( {
                :bitmap => WatchUi.loadResource( options[:icon] as ResourceId ) as BitmapResource
            } );
        }
        
        _label = options[:label] as String;
        _status = options[:status];
        var labelColor = options[:labelColor] as ColorType?;
        _labelColor = labelColor != null ? labelColor : Graphics.COLOR_WHITE;
    }

    private const ICON_WIDTH_FACTOR = 0.1;

    private function initializeDrawables( dc as Dc ) as Void {
        var dcWidth = dc.getWidth();
        var spacing = ( dcWidth * Constants.UI_MENU_ITEM_SPACING_FACTOR ).toNumber();
        var locX = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_LEFT_FACTOR ).toNumber();
        var titleWidth = dcWidth - locX;
        if( _icon != null ) {
            var icon = _icon;
            icon.setLocation( locX, ( ( (dc.getHeight()/2) - icon.height/2 ) * 1.1 ).toNumber() );
            locX += ( dcWidth * ICON_WIDTH_FACTOR ).toNumber() + spacing;
            titleWidth -= locX;
        }

        var paddingRight = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_RIGHT_FACTOR ).toNumber();

        titleWidth -= paddingRight;

        if( _status != null ) {
            var status = _status;
            var statusPaddingRight = ( dcWidth * Constants.UI_MENU_ITEM_STATUS_PADDING_RIGHT_FACTOR ).toNumber();
            if( status instanceof TextStatusDrawable ) {
                status.setAvailableWidth( titleWidth - spacing - statusPaddingRight );
            }
            status.setLocation( dcWidth - paddingRight - statusPaddingRight - status.width, WatchUi.LAYOUT_VALIGN_CENTER );
            titleWidth -= status.width + spacing + statusPaddingRight;
        }

        _labelTextArea = new TextArea( {
            :text => _label,
            :font => Constants.UI_MENU_ITEM_FONTS,
            :locX => locX,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :color => _labelColor,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
            :width => titleWidth,
            :height => dc.getHeight()
        } );
    }

    public function draw( dc as Dc ) as Void {
        if( isFocused() ) {
            System.println( "****** item in focus: " + getId() );
            //dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_BLUE );
            //dc.clear();
        }

        /*
        if( isSelected() ) {
            dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_RED );
            dc.clear();
        }
        */

        if( _labelTextArea == null ) {
            initializeDrawables( dc );
        }
        
        if( _icon != null ) {
            _icon.draw( dc );
        }
        
        ( _labelTextArea as TextArea ).draw( dc );
        
        if( _status != null ) {
            _status.draw( dc );
        }
    }

    public function onSelect() as Void;

    public function setCustomLabel( label as String ) as Void {
        _label = label;
        if( _labelTextArea != null ) {
            _labelTextArea.setText( label );
        }
    }
}