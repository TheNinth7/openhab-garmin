import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

/*
 * Defines the options that can be passed to this `CustomMenu` implementation.
 */
typedef BaseMenuOptions as {
    :title as String,       // title shown in the header
    :itemHeight as Number,  // height of each menu item
    :footer as Drawable?    // footer Drawable to display logo/icons in the footer
};

/*
 * Base class for all `CustomMenu` implementations.
 *
 * As of now, this includes:
 * - `SettingsMenu`
 * - `PageMenu` (used for the sitemap homepage and other pages)
 */
class BaseMenu extends CustomMenu {

    // The Drawable for the title
    private var _title as Text;

    // Constructor
    protected function initialize( options as BaseMenuOptions ) {
        // Logger.debug( "BaseMenu.initialize" );
        // Logger.debug( "BaseMenu.initialize: Homepage=" + ( self instanceof HomepageMenu ) );
        // Logger.debug( "BaseMenu.initialize: Page=" + ( self instanceof PageMenu ) );
        // Logger.debug( "BaseMenu.initialize: Settings=" + ( self instanceof SettingsMenu ) );
        // A title string is provided as input, and this section creates 
        // the corresponding `Drawable` required by the `CustomMenu` superclass.
        _title = new Text( {
            :text => options[:title] as String,
            :color => Constants.UI_COLOR_TEXT,
            :font => Constants.UI_MENU_TITLE_FONT
        } );
        
        // Each subclass may provide its own footer drawable.
        // If none is specified, the footer defaults to the openHAB logo.
        var footer = options[:footer] as Drawable?;
        if( footer == null ) {
            footer = new Bitmap( {
                    :rezId => Rez.Drawables.logoOpenhabText,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } );
        }

        /*
        * Now we start assembling the options for the superclass, beginning with the footer.
        * Note that the title is not passed to the superclass here;
        * instead, this class implements `drawTitle` (see further below).
        */
        var parentOptions = {
            :footer => footer
        };

        /*
        * The heights of the title and footer are defined by a constant.
        * If the constant is set to -1, no height values are passed to the superclass, 
        * which causes the device defaults to be used.
        *
        * For most devices, the default values are applied. Currently, only Garmin Edge 
        * devices override this behavior via their implementation of the `Constants` class.
        */
        if( Constants.UI_MENU_TITLE_HEIGHT != -1 ) {
            parentOptions[:titleItemHeight] = Constants.UI_MENU_TITLE_HEIGHT;
        }
        if( Constants.UI_MENU_FOOTER_HEIGHT != -1 ) {
            parentOptions[:footerItemHeight] = Constants.UI_MENU_FOOTER_HEIGHT;
        }
        
        // Initialize the super class
        CustomMenu.initialize( 
            options[:itemHeight] as Number,
            Constants.UI_COLOR_BACKGROUND, 
            parentOptions );
    }

    // The superclass already defines setTitle() with a Drawable argument,
    // so a different method name must be used here.
    public function setTitleAsString( title as String ) as Void {
        _title.setText( title );
    }

    /*
    * The title needs a background color, which isn't possible when passing 
    * a Drawable to the superclass. 
    * Instead, we override `drawTitle()`, which provides full access 
    * to draw directly on the title area using a `Dc`.
    */
    public function drawTitle( dc as Dc ) as Void {
        // Logger.debug( "BaseMenu.drawTitle" );
        try {
            /*
            * For most devices, we avoid coloring the entire title area to leave a small black bar 
            * separating the colored section from the menu items.
            * However, on some devices—particularly Garmin Edge models—we fill the entire area.
            * The height of the background-colored region is defined in the device-specific 
            * `Constants` implementation.
            */
            var clipHeight = dc.getHeight() * Constants.UI_MENU_TITLE_HEIGHT_FACTOR;

            /*
            * This code causes an issue where the full `Dc` size of the title is incorrectly 
            * applied as the clip area to any subsequently displayed `View` classes 
            * (except when the next view is a `CustomMenu`, which is unaffected).
            *
            * As a workaround, affected views must explicitly call `Dc.clearClip()` 
            * to reset the clipping region.
            */
            dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_MENU_TITLE_BACKGROUND_COLOR );
            dc.setClip( 0, 0, dc.getWidth(), clipHeight );
            dc.clear();
            dc.clearClip();

            // As an alternative workaround for the above-mentioned issue, 
            // we could fill a rectangle with the background color 
            // instead of clearing the `Dc`.
            /*
            dc.setColor( Constants.UI_MENU_TITLE_BACKGROUND_COLOR, Constants.UI_MENU_TITLE_BACKGROUND_COLOR );
            dc.fillRectangle( 0, 0, dc.getWidth(), clipHeight );
            dc.setColor( Constants.UI_COLOR_TEXT, Constants.UI_MENU_TITLE_BACKGROUND_COLOR );
            */

            /*
            * The first time this function is called, we set the Y-position of the title `Drawable`.
            * On Edge devices (with full-height titles), centering the element looks best.
            * On round watch faces (with reduced title height), positioning the title slightly 
            * below center provides more horizontal space and a better visual balance.
            */
            if( _title.locY == 0 ) {
                var locY;
                if( Constants.UI_MENU_TITLE_HEIGHT_FACTOR == 1 ) {
                    locY = WatchUi.LAYOUT_VALIGN_CENTER;
                } else {
                    locY = clipHeight * 0.5 - Graphics.getFontHeight( Constants.UI_MENU_TITLE_FONT ) / 2 + Graphics.getFontDescent( Constants.UI_MENU_TITLE_FONT );
                }
                _title.setLocation( WatchUi.LAYOUT_HALIGN_CENTER, locY );
            }

            // Draw the title
            _title.draw( dc );
        } catch( ex ) {
            ExceptionHandler.handleException( ex );
        }
    }

    // The `CustomMenu` superclass does not expose the number of menu items.
    // To track this, we override the `addItem()` and `deleteItem()` methods.
    private var _itemCount as Number = 0;
    public function addItem( item as CustomMenuItem ) as Void {
        _itemCount++;
        CustomMenu.addItem( item );
    }
    public function deleteItem( index as Number ) as Boolean or Null {
        _itemCount--;
        return CustomMenu.deleteItem( index );
    }
    public function getItemCount() as Number {
        return _itemCount;
    }

    // The settings menu needs a function to focus the first or last item,
    // to support switching between the homepage menu and the parallel settings menu.
    public function focusFirst() as Void {
        setFocus( 0 );
    }
    public function focusLast() as Void {
        setFocus( _itemCount - 1 );
    }
}