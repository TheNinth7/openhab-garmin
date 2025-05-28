import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for menu items representing sitemap elements.
 *
 * Each menu item comprises:
 * - An optional left-side icon (`ResourceId`), currently not updatable
 * - A center label, passed in as `String` and updatable via `setLabel()`
 * - An optional right-side status indicator (`Drawable`), updatable by updating the Drawable itself
 * - An optional action icon, used to indicate that selecting the item will trigger an action.
 *   This icon should be shown only if the label or status does not clearly convey that an action is available.
 *   For example, `Frame` and toggle-style `Switch` elements do not display an action icon.
 *   In contrast, `Slider` elements and standard `Switch` elements with text-based statuses do display it.
 */

// Defines the options accepted by the `BaseSitemapMenuItem` class.
typedef BaseSitemapMenuItemOptions as {
    :id as Object,
    :icon as ResourceId?,
    :label as String,
    :labelColor as ColorType?,
    :status as Drawable?,
    :isActionable as Boolean? // if true, the action icon is displayed
};

class BaseSitemapMenuItem extends BaseMenuItem {

    private var _icon as Drawable?; // icon is optional
    private var _label as String;
    private var _labelColor as ColorType; // color the label text shall be printed in
    private var _labelTextArea as TextArea?; // label Drawable, optional because instantiated only when drawn
    private var _status as Drawable?; // status is optional
    private var _isActionable as Boolean; // true if the action icon shall be displayed

    // The action icon is the same for all menu items, it is therefore
    // loaded once as static member
    private static var _isActionableIcon as Bitmap = new Bitmap( {
        :rezId => Rez.Drawables.iconRight
    } );

    // Function for updating the label
    // The base class CustomItem already has a setLabel function,
    // so we need to use the same signature, but will throw an
    // exception for ResourceId
    public function setLabel( label as String or ResourceId ) as Void {
        if( ! ( label instanceof String ) ) {
            throw new GeneralException( "BaseSitemapMenuItem supports only String labels" );
        }
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
    public function update( sitemapElement as SitemapElement ) as Void { 
        throw new AbstractMethodException( "BaseSitemapMenuItem.update" );
    }

    // Constructor
    protected function initialize( options as BaseSitemapMenuItemOptions ) {
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

        // isActionable defaults to false
        var isActionable = options[:isActionable] as Boolean?;
        _isActionable = isActionable == null ? false : isActionable;

        // Label color will default to white
        var labelColor = options[:labelColor] as ColorType?;
        _labelColor = labelColor != null ? labelColor : Constants.UI_COLOR_TEXT;
    }

    // Called by the base class to render the menu item.
    public function onUpdate( dc as Dc ) as Void {
        updateDrawables( dc );
    
        if( _icon != null ) {
            _icon.draw( dc );
        }
        
        ( _labelTextArea as TextArea ).draw( dc );       
        if( _status != null ) {
            _status.draw( dc );
            // Action item is only applied if a status is shown
            if( _isActionable ) {
                _isActionableIcon.draw( dc );
            }
        }
    }

   /*
    * We intentionally do not use `onLayout()`. Instead, the layout is updated 
    * during every `onUpdate()` call, as changes to the sitemap may affect 
    * the layout dynamically.
    *
    * The layout is governed by the sizes of the individual elements and 
    * spacing constants that define the gaps between them.
    *
    * For more details, refer to `DefaultConstants`, where these constants are defined 
    * and their relationships are visually explained.
    */
    private function updateDrawables( dc as Dc ) as Void {
        var dcWidth = dc.getWidth();
        
        // Calculate spacing and left padding
        var spacing = ( dcWidth * Constants.UI_MENU_ITEM_SPACING_FACTOR ).toNumber();
        // Throughout this function, leftX is the current position
        // of elements that are aligned to the left (icon and label)
        // Initially, the left padding is applied
        var leftX = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_LEFT_FACTOR ).toNumber();
        
        // If there is an icon, we initialize it and
        // then set leftX to the position next to it
        // Also the title width is adjusted
        if( _icon != null ) {
            var icon = _icon;
            icon.setLocation( leftX, ( ( (dc.getHeight()/2) - icon.height/2 ) * 1.1 ).toNumber() );
            leftX += Constants.UI_MENU_ITEM_ICON_WIDTH + spacing;
        }

        // Available width for the title is reduced by the 
        // space to the left (left-padding, icon, spacing)
        var titleWidth = dcWidth - leftX;

        // Right padding is calculated
        var paddingRight = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_RIGHT_FACTOR ).toNumber();
        // Throughout this function, rightX is the current position
        // of elements that are aligned to the right (status and action icon)
        // Initially, the right padding is applied
        var rightX = dcWidth - paddingRight;

        // The 
        if( _status != null || _isActionable ) {
            rightX -= ( dcWidth * Constants.UI_MENU_ITEM_STATUS_PADDING_RIGHT_FACTOR ).toNumber();
        }        

        if( _isActionable ) {
            rightX -= _isActionableIcon.width;
            if( _isActionableIcon.locX == 0 ) {
                _isActionableIcon.setLocation( rightX, WatchUi.LAYOUT_VALIGN_CENTER );
            }
            rightX -= ( dcWidth * Constants.UI_MENU_ITEM_ACTION_PADDING_LEFT_FACTOR ).toNumber();
        }

        titleWidth -= dcWidth - rightX;

        // If status is present, its location is set,
        // and width available for the title is adjusted
        // accordingly
        if( _status != null ) {
            var status = _status;
            titleWidth -= spacing;
            
            if( status instanceof StatusTextArea ) {
                status.setAvailableWidth( titleWidth.toNumber() );
            } else if( status instanceof Text && ! ( status instanceof StatusText ) ) {
                throw new GeneralException( "BaseSitemapMenuItem does not support Text, use StatusText instead" );
            }

            var statusWidth = 
                status instanceof StatusText
                ? status.precomputedWidth
                : status.width;
            
            rightX -= statusWidth;

            status.setLocation( rightX, WatchUi.LAYOUT_VALIGN_CENTER );

            titleWidth -= statusWidth;
        }

        // Finally the text area is initialized
        // At the calculated leftX and width
        _labelTextArea = new TextArea( {
            :text => _label,
            :font => Constants.UI_MENU_ITEM_FONTS,
            :locX => leftX,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :color => _labelColor,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
            :width => titleWidth,
            :height => dc.getHeight()
        } );
    }
}