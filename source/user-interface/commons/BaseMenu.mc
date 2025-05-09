import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

// Definition of the options that can be passed into this
// implementation of the CustomMenu
typedef BaseMenuOptions as {
    :title as String,       // title shown in the header
    :itemHeight as Number,  // height of each menu item
    :footer as Drawable?    // footer Drawable to display logo/icons in the footer
};

/*
    Base class for all CustomMenu implementations.
    At the time of writing, this is the 
    - SettingsMenu and the
    - PageMenu, which represent the sitemap homepage or another page
*/ 
class BaseMenu extends CustomMenu {

    // The Drawable for the title
    private var _title as Text;

    // Constructor
    protected function initialize( options as BaseMenuOptions ) {
        // As title a string is passed in, and here the
        // corresponding Drawable for the super class CustomMenu
        // is created.
        _title = new Text( {
            :text => options[:title] as String,
            :color => Graphics.COLOR_WHITE,
            :font => Constants.UI_MENU_TITLE_FONT
        } );
        
        // For the footer each derivate of this class may use
        // its own drawable. If no footer is passed in,
        // it defaults to the openHAB logo
        var footer = options[:footer] as Drawable?;
        if( footer == null ) {
            footer = new Bitmap( {
                    :rezId => Rez.Drawables.logoOpenhabText,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } );
        }

        // Now we start assembling the options for the super class,
        // starting with the footer
        // Note that the title is not passed to the super class here,
        // instead this class implements drawTitle (see further below)
        var parentOptions = {
            :footer => footer
        };

        // The height of title and footer are stored in a constant
        // if the constant is set to -1, no heights will be passed
        // to the super class, effectively setting them to their
        // device defaults
        // For most devices the default is applied, currently only
        // the Garmin Edge devices have a different setting in their
        // implementation of the Constants class.
        if( Constants.UI_MENU_TITLE_HEIGHT != -1 ) {
            parentOptions[:titleItemHeight] = Constants.UI_MENU_TITLE_HEIGHT;
        }
        if( Constants.UI_MENU_FOOTER_HEIGHT != -1 ) {
            parentOptions[:footerItemHeight] = Constants.UI_MENU_FOOTER_HEIGHT;
        }
        
        // Initialize the super class
        CustomMenu.initialize( 
            options[:itemHeight] as Number,
            Graphics.COLOR_BLACK, 
            parentOptions );
    }

    // The super class already has a setTitle accepting a Drawable,
    // so we have to use a different name here.
    public function setTitleAsString( title as String ) as Void {
        _title.setText( title );
    }

    // The title should get a background color, which is not possible
    // when passing a Drawable to the super class. So instead we
    // implement drawTitle(), where we have full access to draw on the
    // title area via a Dc.
    public function drawTitle( dc as Dc ) as Void {
        
        // For most devices we do not want to color the whole title area,
        // but leave a small black bar to separate the colored area from the
        // menu items. However for some devices, we want to fill the full area,
        // in particular the Garmin Edge devices. Therefore the height
        // of the area that is filled with the background color is defined
        // in the device-specific Constants implementation
        var clipHeight = dc.getHeight() * Constants.UI_MENU_TITLE_HEIGHT_FACTOR;

        /* 
            This code leads to an issue where the size of the full Dc of the
            title is applied as clip area on any subsequently displayed View
            classes. (there is no issue if the next view displayed is a CustomMenu)
            As workaround, these classes need to make a call to Dc.clearClip().
        */
        dc.setColor( Graphics.COLOR_WHITE, Constants.UI_MENU_TITLE_BACKGROUND_COLOR );
        dc.setClip( 0, 0, dc.getWidth(), clipHeight );
        dc.clear();
        dc.clearClip();

        // As alternative workaround for the above-mentioned issue we could also
        // fill a rectangle instead of clearing the Dc with the background color.
        /*
        dc.setColor( Constants.UI_MENU_TITLE_BACKGROUND_COLOR, Constants.UI_MENU_TITLE_BACKGROUND_COLOR );
        dc.fillRectangle( 0, 0, dc.getWidth(), clipHeight );
        dc.setColor( Graphics.COLOR_WHITE, Constants.UI_MENU_TITLE_BACKGROUND_COLOR );
        */

        // The first time this function is called, we set the Y position of
        // the title Drawable. On the Edge devices, where the title is full
        // height, it looks good to center the element. On round watch faces,
        // where the height is reduced, the title is placed a bit lower than
        // center, this gives it more horizontal space and looks more balanced.
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
    }

    // The CustomMenu super class does not provide access to the
    // number of menu items. Therefore we override the addItem()
    // and deleteItem() functions here to keep track.
    private var _itemCount as Number = 0;
    public function addItem( item as CustomMenuItem ) as Void {
        _itemCount++;
        CustomMenu.addItem( item );
    }
    public function deleteItem( index as Number ) as Boolean or Null {
        _itemCount--;
        return CustomMenu.deleteItem( index );
    }
    // Touch devices need access to the number of items,
    // see HomepageMenu for details
    (:exclForButton)
    public function getItemCount() as Number {
        return _itemCount;
    }

    // For the settings menu, we need a function to focus the
    // first or last element for switching back and forth
    // between the homepage menu and the the parallel settings menu.
    public function focusFirst() as Void {
        setFocus( 0 );
    }
    public function focusLast() as Void {
        setFocus( _itemCount - 1 );
    }
}