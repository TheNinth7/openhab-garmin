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
    :sitemapWidget as SitemapWidget?,
    :icon as ResourceId?,
    :label as String,
    :labelColor as ColorType?,
    :state as Drawable?,
    :isActionable as Boolean? // if true, the action icon is displayed
};

class BaseSitemapMenuItem extends BaseMenuItem {

    private var _icon as Drawable?; // icon is optional
    private var _title as String;
    private var _labelColor as ColorType; // color the label text shall be printed in
    private var _labelTextArea as TextArea?; // label Drawable, optional because instantiated only when drawn
    private var _state as Drawable?; // state is optional
    private var _stateColor as ColorType?; // color passed to the state drawable
    private var _isActionable as Boolean; // true if the action icon shall be displayed

    // The action icon is the same for all menu items, it is therefore
    // loaded once as static member
    private static var _isActionableIcon as Bitmap = new Bitmap( {
        :rezId => Rez.Drawables.iconRight
    } );

    // Constructor
    protected function initialize( options as BaseSitemapMenuItemOptions ) {
        BaseMenuItem.initialize();

        // Icon is passed in as ResourceId and we create a Bitmap Drawable from it
        if( options[:icon] != null ) {
            _icon = new Bitmap( {
                :bitmap => WatchUi.loadResource( options[:icon] as ResourceId ) as BitmapResource
            } );
        }
        
        _state = options[:state];

        // isActionable defaults to false
        var isActionable = options[:isActionable] as Boolean?;
        _isActionable = isActionable == null ? false : isActionable;

        var sitemapWidget = options[:sitemapWidget] as SitemapWidget?;

        if( sitemapWidget != null ) {
            _title = sitemapWidget.label;
            _labelColor = setLabelColor( sitemapWidget.labelColor );
            _stateColor = setStateColor( sitemapWidget.valueColor );
        } else {
            _title = options[:label] as String;
            _labelColor = setLabelColor( options[:labelColor] );
        }
    }

    public function getLabel() as String {
        return _title;
    }

    /*
    * `isMyType()`: Required override to determine if a given sitemap element matches this item type.
    */
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean { 
        throw new AbstractMethodException( "BaseSitemapMenuItem.getItemType" );
    }

    /*
    * `onSelect()`: Optional override to handle item selection (e.g., Enter button or touch tap).
    */
    public function onSelect() as Void;

    // Called by the base class to render the menu item.
    public function onUpdate( dc as Dc ) as Void {
        updateDrawables( dc );
    
        if( _icon != null ) {
            _icon.draw( dc );
        }
        
        ( _labelTextArea as TextArea ).draw( dc );       
        if( _state != null ) {
            _state.draw( dc );
            // Action item is only applied if a status is shown
            if( _isActionable ) {
                _isActionableIcon.draw( dc );
            }
        }
    }

    // Set the colors or apply the defaults
    private function setLabelColor( labelColor as ColorType? ) as ColorType {
        return labelColor != null ? labelColor : Constants.UI_COLOR_TEXT;
    }
    private function setStateColor( stateColor as ColorType? ) as ColorType {
        return stateColor != null ? stateColor : Constants.UI_COLOR_INACTIVE;
    }

    /*
    * `update()`: Optional override to refresh the menu item content with new data from the sitemap request.
    */
    public function update( sitemapWidget as SitemapWidget ) as Void { 
        _title = sitemapWidget.label;
        _labelColor = setLabelColor( sitemapWidget.labelColor );
        _stateColor = setStateColor( sitemapWidget.valueColor );
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

        if( _state != null || _isActionable ) {
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
        if( _state != null ) {
            var status = _state;
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

            if( status has :setColor && _stateColor != null ) {
                status.setColor( _stateColor );
            }
        }

        // Finally the text area is initialized
        // At the calculated leftX and width
        _labelTextArea = new TextArea( {
            :text => _title,
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