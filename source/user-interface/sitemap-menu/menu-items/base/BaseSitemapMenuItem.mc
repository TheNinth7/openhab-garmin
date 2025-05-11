import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for menu items representing sitemap elements.
 *
 * Each menu item comprises:
 * - A left-side icon (`ResourceId`), currently not updatable
 * - A center label, passed in as `String` and updatable via `setCustomLabel()`
 * - A right-side status indicator (`Drawable`), updatable by updating the Drawable itself
 */
class BaseSitemapMenuItem extends BaseMenuItem {

    private var _icon as Drawable?; // icon is optional
    private var _label as String;
    private var _labelColor as ColorType; // color the label text shall be printed in
    private var _labelTextArea as TextArea?; // label Drawable, optional because instantiated only when drawn
    private var _status as Drawable?; // status is optional

    // Function for updating the label
    // The base class CustomItem already has a setLabel function,
    // so we need to use a different name here
    public function setCustomLabel( label as String ) as Void {
        _label = label;
        if( _labelTextArea != null ) {
            _labelTextArea.setText( label );
        }
    }
    public function getLabel() as String {
        return _label;
    }

    /*
    * `onSelect()`: Optional override to handle item selection (e.g., Enter button or touch tap).
    * `isMyType()`: Required override to determine if a given sitemap element matches this item type.
    * `update()`: Required override to refresh the menu item content with new data from the sitemap request.
    */
    public function onSelect() as Void;
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean { 
        throw new AbstractMethodException( "BaseSitemapMenuItem.getItemType" );
    }
    public function update( sitemapElement as SitemapElement ) as Boolean { 
        throw new AbstractMethodException( "BaseSitemapMenuItem.update" );
    }

    // Constructor
    protected function initialize( options as BaseMenuItemOptions ) {
        BaseMenuItem.initialize( options );

        // Icon is passed in as ResourceId and we create a Bitmap Drawable from it
        if( options[:icon] != null ) {
            _icon = new Bitmap( {
                :bitmap => WatchUi.loadResource( options[:icon] as ResourceId ) as BitmapResource
            } );
        }
        
        // Save the other values passed in
        _label = options[:label] as String;
        _status = options[:status];
        
        // Label color will default to white
        var labelColor = options[:labelColor] as ColorType?;
        _labelColor = labelColor != null ? labelColor : Graphics.COLOR_WHITE;
    }

    // Called by the base class to render the menu item.
    public function drawImpl( dc as Dc ) as Void {
        // In the first call, the drawables are initialized
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


    /*
    * Drawables can only be initialized in `drawImpl()` because a `Dc` is required
    * to determine their dimensions.
    */
    private function initializeDrawables( dc as Dc ) as Void {
        var dcWidth = dc.getWidth();
        
        // Calculate spacing and left padding
        var spacing = ( dcWidth * Constants.UI_MENU_ITEM_SPACING_FACTOR ).toNumber();
        // locX is initially set to the left + padding
        var locX = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_LEFT_FACTOR ).toNumber();
        // Available width for the title is reduced by the left padding
        var titleWidth = dcWidth - locX;
        
        // If there is an icon, we initialize it and
        // then set locX to the position next to it
        // Also the title width is adjusted
        if( _icon != null ) {
            var icon = _icon;
            icon.setLocation( locX, ( ( (dc.getHeight()/2) - icon.height/2 ) * 1.1 ).toNumber() );
            locX += Constants.UI_MENU_ITEM_ICON_WIDTH + spacing;
            titleWidth -= locX;
        }

        // Right padding is calculated and the title width is adjusted accordingly
        var paddingRight = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_RIGHT_FACTOR ).toNumber();
        titleWidth -= paddingRight;

        // If status is present, its location is set,
        // and width available for the title is adjusted
        // accordingly
        if( _status != null ) {
            var status = _status;
            var statusPaddingRight = ( dcWidth * Constants.UI_MENU_ITEM_STATUS_PADDING_RIGHT_FACTOR ).toNumber();
            if( status instanceof TextStatusDrawable ) {
                status.setAvailableWidth( titleWidth - spacing - statusPaddingRight );
            }
            status.setLocation( dcWidth - paddingRight - statusPaddingRight - status.width, WatchUi.LAYOUT_VALIGN_CENTER );
            titleWidth -= status.width + spacing + statusPaddingRight;
        }

        // Finally the text area is initialized
        // At the calculated locX and width
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
}