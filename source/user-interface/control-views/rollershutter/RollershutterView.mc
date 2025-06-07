import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Full-screen view based on CustomView to display a rollershutter switch.
 * Provides "Up", "Down", and "Stop" functions, along with the current numeric state.
 *
 * This class handles display only. User input is managed by `RollershutterDelegate`,
 * and commands are sent via `RollershutterMenuItem`.
 */
class RollershutterView extends CustomView {

    // The sitemap element associated with this view
    private var _sitemapSwitch as SitemapSwitch;

    // For drawing the title we use a TextArea, which
    // dynamically chooses the font size and applies line breaks if needed
    private var _titleDrawable as TextArea?;
    
    // The Drawable for drawing the current state
    private var _stateDrawable as Text?;

    // Constructor
    public function initialize( sitemapSwitch as SitemapSwitch ) {
        CustomView.initialize();
        _sitemapSwitch = sitemapSwitch;
    }

    // onLayout is called once when the view is opened,
    // and initiates all the Drawables   
    public function onLayout( dc as Dc ) as Void {
        // Logger.debug( "RollershutterView.onLayout" ) );

        var dcHeight = dc.getHeight();
        var dcWidth = dc.getWidth();

        // The title
        _titleDrawable = new TextArea( {
            :text => _sitemapSwitch.label,
            :font => Constants.UI_PICKER_TITLE_FONTS,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => dcHeight * 0.075,
            :width => dcWidth * 0.5,
            :height => dcHeight * 0.2
        } );
        addDrawable( _titleDrawable );

        // Vertical starting point of the controls
        // and the current state. All these Drawables are
        // placed relative to this point.
        var yStart = 0.375;
        
        // The text field showing the current value
        _stateDrawable = new CustomText( {
            :font => Graphics.FONT_LARGE,
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => 0.5, // We do not use WatchUi.LAYOUT_HALIGN_CENTER because that would override :justification
            :locY => yStart + 0.25
        } );
        addDrawable( _stateDrawable );

        // Fill the text
        updateStateDrawable();

        // The up/down arrows
        addDrawable( new CustomBitmap( {
            :rezId => Rez.Drawables.chevronUpGrey,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => yStart
        } ) );
        addDrawable( new CustomBitmap( {
            :rezId => Rez.Drawables.chevronDownGrey,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => yStart + 0.5
        } ) );

        // Touch areas for the up/down arrows.
        //
        // These areas cover the entire screen:
        // - Anything above the vertical center of the current Pickable is considered "up".
        // - Anything below is considered "down".
        //
        // The smaller touch area for stop is defined afterward,
        // and they take precedence over the up/down areas.
        addTouchArea( 
            new RectangularTouchArea( 
                :touchUp, 
                0, 
                0, 
                dcWidth, 
                ( dcHeight*(yStart+0.25) ).toNumber()
        ) );
        addTouchArea( 
            new RectangularTouchArea( 
                :touchDown, 
                0, 
                ( dcHeight*(yStart+0.25) ).toNumber(), 
                dcWidth, 
                dcHeight
        ) );

        // There are different implementations for
        // button- and touch-based devices
        addInputHints( yStart + 0.25 );
    }

    // On button-based devices we use the input hints
    // feature of the CustomView
    (:exclForTouch)
    private function addInputHints( y as Float ) as Void {
        addInputHint( InputHint.HINT_KEY_ENTER, InputHint.HINT_TYPE_STOP, :touchCheck );
    }

    // On touch-based devices we place an icon for stop
    // The icon is instantiated as CustomBitmap with
    // a touchId defined, which will automatically add
    // its touch area to the CustomView
    (:exclForButton)
    private function addInputHints( y as Float ) as Void {
        var xSpace = 0.15;
        addDrawable( new CustomBitmap( {
            :rezId => Rez.Drawables.iconStop,
            :locX => 1 - xSpace,
            :locY => y,
            :touchId => :touchStop
        } ) );
    }

    // Function to fill the text of the state drawable
    private function updateStateDrawable() as Void {
        if( _stateDrawable != null ) {
            var stateDrawable = _stateDrawable as Text;
            // In the view, we'll show the numeric state, 
            // regardless of any mappings. If the state
            // is not numeric, we'll leave it at the previous
            // state.
            if( _sitemapSwitch.item.state.toNumber() != null ) {
                stateDrawable.setText( 
                    _sitemapSwitch.item.state 
                    + _sitemapSwitch.item.unit
                );
            }
        }
    }

    // This function is called when an updated sitemap is received.
    // In this case it is not necessary to call WatchUi.requestUpdate(),
    // since this is done by the update algorithm
    public function updateWidget( sitemapSwitch as SitemapSwitch ) as Void {
        _sitemapSwitch = sitemapSwitch;
        
        if( _titleDrawable != null ) {
            _titleDrawable.setText( _sitemapSwitch.label );
        }
        
        updateStateDrawable();
    }
}