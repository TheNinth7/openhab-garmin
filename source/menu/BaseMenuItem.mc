import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

typedef BaseMenuItemOptions as {
    :icon as Drawable?,
    :label as String,
    :status as Drawable?
};


class BaseMenuItem extends CustomMenuItem {

    private var _icon as Drawable?;
    private var _label as String;
    private var _labelTextArea as TextArea?;
    private var _status as Drawable?;

    protected function initialize( sitemapElement as SitemapElement, options as BaseMenuItemOptions ) {
        CustomMenuItem.initialize( sitemapElement.id, {} );
        _icon = options[:icon];
        _label = options[:label] as String;
        _status = options[:status];
    }

    private const ICON_WIDTH_PERCENTAGE = 0.2;
    private const STATUS_WIDTH_PERCENTAGE = 0.2;
    private const SPACING_PERCENTAGE = 0.05;

    private function initializeDrawables( dc as Dc ) as Void {
        var titleWidth = dc.getWidth();
        var titleLocX = 0;
        if( _icon != null ) {
            _icon.setLocation( 0, 0 );
            titleLocX = ( dc.getWidth() * ICON_WIDTH_PERCENTAGE ).toNumber();
            titleWidth -= dc.getWidth() * ( ICON_WIDTH_PERCENTAGE + SPACING_PERCENTAGE );
        }

        if( _status != null ) {
            _status.setLocation( dc.getWidth() * ( 1 - STATUS_WIDTH_PERCENTAGE ), WatchUi.LAYOUT_VALIGN_CENTER );
            titleWidth -= dc.getWidth() * ( STATUS_WIDTH_PERCENTAGE + SPACING_PERCENTAGE );
        }

        _labelTextArea = new TextArea( {
            :text => _label,
            :font => [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY],
            :locX => titleLocX,
            :locY => 0,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :color => Graphics.COLOR_WHITE,
            :backgroundColor => Graphics.COLOR_BLACK,
            :width => titleWidth,
            :height => dc.getHeight()
        } );
    }

    public function draw( dc as Dc ) as Void {
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

    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return false;
    }

    public function setCustomLabel( label as String ) as Void {
        _label = label;
        if( _labelTextArea != null ) {
            _labelTextArea.setText( label );
        }
    }
    /*
    public function updateBaseItem( sitemapElement as SitemapElement, options as BaseMenuItemOptions ) as Boolean {
        _icon = options[:icon];
        var status = options[:status];

        if( ! ( ( status == null && _status == null )
             || ( status != null && _status != null ) ) ) 
        {
            _labelTextArea = null;
        }

        if( _labelTextArea != null ) {
            _labelTextArea.setText( options[:label] as String );
        }
        return true;
    }
    */
}