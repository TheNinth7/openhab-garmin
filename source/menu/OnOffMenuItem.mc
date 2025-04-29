import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

class OnOffMenuItem extends SwitchMenuItem {
    private var _isEnabled as Boolean;
    private var _statusDrawable as OnOffStatusDrawable;

    private static const ITEM_STATE_ON = "ON";
    private static const ITEM_STATE_OFF = "OFF";

    public static function getItemType() as String {
        return "Switch";
    }

    public function getNextCommand() as String {
        return _isEnabled ? ITEM_STATE_OFF : ITEM_STATE_ON;
    }
    public function updateItemState( state as String ) as Void {
        _isEnabled = parseItemState( state );
        _statusDrawable.setEnabled( _isEnabled );
    }

    private function parseItemState( itemState as String ) as Boolean {
        if( itemState.equals( ITEM_STATE_ON ) ) {
            return true;            
        } else if( itemState.equals( ITEM_STATE_OFF ) ) {
            return false;
        } else {
            throw new GeneralException( "OnOffMenuItem: state '" + itemState + "' is not supported" );
        }
    }

    public function initialize( sitemapSwitch as SitemapSwitch ) {
        var itemState = sitemapSwitch.itemState;
        if( ! ( itemState.equals( ITEM_STATE_ON ) || itemState.equals( ITEM_STATE_OFF ) ) ) {      
            throw new JsonParsingException( "Switch '" + sitemapSwitch.label + "': invalid state '" + itemState + "'" );
        }
        _isEnabled = parseItemState( sitemapSwitch.itemState );
        _statusDrawable = new OnOffStatusDrawable( _isEnabled );
        SwitchMenuItem.initialize( sitemapSwitch, _statusDrawable );
    }

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return 
               sitemapElement instanceof SitemapSwitch 
            && sitemapElement.itemType.equals( OnOffMenuItem.getItemType() );
    }

}

class OnOffStatusDrawable extends Bitmap {
    
    private var _bufferedBitmap as BufferedBitmap;

    private const HEIGHT = ( PageMenu.ITEM_HEIGHT * 0.8 ).toNumber();
    private const WIDTH = ( PageMenu.ITEM_HEIGHT * 0.4 ).toNumber();
    private const OUTER_CIRCLE_FACTOR = 0.8;
    private const INNER_CIRCLE_FACTOR = 0.85;

    public function initialize( isEnabled as Boolean ) {
        _bufferedBitmap = Graphics.createBufferedBitmap( {
            :width => WIDTH,
            :height => HEIGHT,
        } ).get() as BufferedBitmap;
        
        Bitmap.initialize( {
            :bitmap => _bufferedBitmap
        } );

        setEnabled( isEnabled );
    }

    public function setEnabled( isEnabled as Boolean ) as Void {
        var dc = _bufferedBitmap.getDc();
        dc.clear();

        if( isEnabled ) {
            dc.setColor( 0xe64a19, Graphics.COLOR_BLACK );
            // dc.setFill( 0xe64a19 );
        } else {
            dc.setColor( Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK );
            // dc.setFill( Graphics.COLOR_LT_GRAY );
        }
        
        var spacing = ( dc.getWidth() * (1-OUTER_CIRCLE_FACTOR) / 2 ).toNumber();
        var radius = (dc.getWidth()/2).toNumber() - spacing;
        var xCenter = spacing + radius;
        var upperYCenter = xCenter;
        var lowerYCenter = dc.getHeight() - spacing - radius;
        dc.setPenWidth( 1 );
        dc.setAntiAlias( true );
        dc.fillCircle( xCenter, upperYCenter, radius );
        dc.fillCircle( xCenter, lowerYCenter, radius );
        // Correction values -1 and + 3 have been determined by
        // trial and error and tested on different devices
        dc.fillRectangle( xCenter-radius-1, upperYCenter, radius*2 + 3, lowerYCenter - upperYCenter );

        dc.setColor( Graphics.COLOR_BLACK, Graphics.COLOR_BLACK );
        // dc.setFill( Graphics.COLOR_BLACK );

        var toggleCenter = isEnabled ? upperYCenter : lowerYCenter;
        dc.fillCircle( xCenter, toggleCenter, radius * INNER_CIRCLE_FACTOR );
    }
}
/* Simpler version showing ON and OFF as text
class OnOffStatusDrawable extends Text {
    public function initialize( isEnabled as Boolean ) {
        Text.initialize( {
            :text => getStatusText( isEnabled ),
            :font => Graphics.FONT_SMALL,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        } );
    }
    public function setEnabled( isEnabled as Boolean ) as Void {
        setText( getStatusText( isEnabled ) );
    }
    private function getStatusText( isEnabled as Boolean ) as String {
        return isEnabled ? "ON" : "OFF";
    }
}
*/