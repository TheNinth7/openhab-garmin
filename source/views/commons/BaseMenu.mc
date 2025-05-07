import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

typedef BaseMenuOptions as {
    :title as String,
    :itemHeight as Number,
    :footer as Drawable?
};

class BaseMenu extends CustomMenu {

    private var _title as Text;

    protected function initialize( options as BaseMenuOptions ) {
        _title = new Text( {
            :text => options[:title] as String,
            :color => Graphics.COLOR_WHITE,
            :font => Constants.UI_MENU_TITLE_FONT
        } );
        
        var footer = options[:footer] as Drawable?;

        if( footer == null ) {
            footer = new Bitmap( {
                    :rezId => Rez.Drawables.logoOpenhabText,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } );
        }

        CustomMenu.initialize( 
            options[:itemHeight] as Number,
            Graphics.COLOR_BLACK, 
            {
                :footer => footer
            } );
    }

    
    public function setTitleAsString( title as String ) as Void {
        _title.setText( title );
    }
    public function drawTitle( dc as Dc ) as Void {
        var clipHeight = dc.getHeight() * Constants.UI_MENU_TITLE_HEIGHT_FACTOR;
        dc.setClip( 0, 0, dc.getWidth(), clipHeight );
        dc.setColor( Graphics.COLOR_WHITE, Constants.UI_MENU_TITLE_BACKGROUND_COLOR );
        dc.clear();
        if( _title.locY == 0 ) {
            var locY;
            if( Constants.UI_MENU_TITLE_HEIGHT_FACTOR == 1 ) {
                locY = WatchUi.LAYOUT_VALIGN_CENTER;
            } else {
                locY = clipHeight * 0.5 - Graphics.getFontHeight( Constants.UI_MENU_TITLE_FONT ) / 2 + Graphics.getFontDescent( Constants.UI_MENU_TITLE_FONT );
            }
            _title.setLocation( WatchUi.LAYOUT_HALIGN_CENTER, locY );
        }
        //dc.drawLine( 0, clipHeight*0.5, dc.getWidth(), clipHeight*0.5 );
        _title.draw( dc );
    }
    
    private var _itemCount as Number = 0;
    public function addItem( item as CustomMenuItem ) as Void {
        _itemCount++;
        CustomMenu.addItem( item );
    }
    public function deleteItem( index as Number ) as Boolean or Null {
        _itemCount--;
        return CustomMenu.deleteItem( index );
    }
    (:exclForButton)
    public function getItemCount() as Number {
        return _itemCount;
    }
    public function focusFirst() as Void {
        setFocus( 0 );
    }
    public function focusLast() as Void {
        setFocus( _itemCount - 1 );
    }
}