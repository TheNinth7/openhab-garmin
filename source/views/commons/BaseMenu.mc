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
    private static const TITLE_FONT = Graphics.FONT_SMALL;  
    private static const TITLE_HEIGHT_FACTOR = 0.8;

    protected function initialize( options as BaseMenuOptions ) {
        _title = new Text( {
            :text => options[:title] as String,
            :color => Graphics.COLOR_WHITE,
            :font => TITLE_FONT
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
        var clipHeight = dc.getHeight() * TITLE_HEIGHT_FACTOR;
        dc.setClip( 0, 0, dc.getWidth(), clipHeight );
        dc.setColor( Graphics.COLOR_WHITE, AppProperties.getMenuTitleBackgroundColor() );
        dc.clear();
        if( _title.locY == 0 ) {
            _title.setLocation( WatchUi.LAYOUT_HALIGN_CENTER, clipHeight * 0.5 - Graphics.getFontHeight( TITLE_FONT ) / 2.5 );
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
    public function focusFirst() as Void {
        setFocus( 0 );
    }
    public function focusLast() as Void {
        setFocus( _itemCount - 1 );
    }
}