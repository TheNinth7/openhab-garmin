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

    public function getLabel() as String {
        return _label;
    }

    protected function initialize( sitemapElement as SitemapElement, options as BaseMenuItemOptions ) {
        CustomMenuItem.initialize( sitemapElement.id, {} );
        _icon = options[:icon];
        _label = options[:label] as String;
        _status = options[:status];
    }

    private const ICON_WIDTH_FACTOR = 0.2;
    private const SPACING_FACTOR = 0.03;

    private function initializeDrawables( dc as Dc ) as Void {
        var spacing = dc.getWidth() * SPACING_FACTOR;
        var locX = spacing;
        var titleWidth = dc.getWidth() - spacing;
        if( _icon != null ) {
            _icon.setLocation( locX, 0 );
            locX += ( dc.getWidth() * ICON_WIDTH_FACTOR ).toNumber() + spacing;
            titleWidth -= locX;
        }

        if( _status != null ) {
            var status = _status;
            status.setLocation( dc.getWidth() - status.width - spacing*2, WatchUi.LAYOUT_VALIGN_CENTER );
            titleWidth -= status.width + spacing*3;
        }

        _labelTextArea = new TextArea( {
            :text => _label,
            :font => [Graphics.FONT_SMALL, Graphics.FONT_TINY, Graphics.FONT_GLANCE, Graphics.FONT_XTINY],
            :locX => locX,
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
        throw new AbstractMethodException( "BaseMenuItem.getItemType" );
    }
    public function update( sitemapElement as SitemapElement ) as Boolean { 
        throw new AbstractMethodException( "BaseMenuItem.update" );
    }
    public function onSelect() as Void;

    public function setCustomLabel( label as String ) as Void {
        _label = label;
        if( _labelTextArea != null ) {
            _labelTextArea.setText( label );
        }
    }
}