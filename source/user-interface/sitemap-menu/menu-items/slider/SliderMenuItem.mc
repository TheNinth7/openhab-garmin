import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item represents the Slider widget in the app.
 * It displays the current slider value and, when selected,
 * opens a separate view (a CustomPicker implementation) that allows
 * the user to adjust the value.
 *
 * The widgets respects sitemap settings for minValue, maxValue, and step.
 * It also supports 'releaseOnly' mode: if enabled, the item state is updated
 * only after the user confirms their selection. If disabled, the state updates
 * continuously as the user scrolls through values.
 */
class SliderMenuItem extends BaseSitemapMenuItem {

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return 
            sitemapWidget instanceof SitemapSlider
            && sitemapWidget.item.hasState();
    }

    // The text status Drawable
    private var _statusText as Text;

    // Since we need a bunch of values from the slider configuration,
    // we just keep the SitemapSlider
    private var _sitemapSlider as SitemapSlider;
    public function getSitemapSlider() as SitemapSlider {
        return _sitemapSlider;
    }
    
    // For changing the state of the slider
    private var _commandRequest as BaseCommandRequest?;

    // Constructor
    // Initializes the BaseCommandRequest used for changing the state,
    // the Drawable for the displayed status and the superclass
    public function initialize( sitemapSlider as SitemapSlider ) {
        _sitemapSlider = sitemapSlider;
        _commandRequest = BaseCommandRequest.get( self );

        // The status shown in the menu item
        _statusText = new StatusText( 
            sitemapSlider.numericState.toString() + sitemapSlider.unit
        );
        
        BaseSitemapMenuItem.initialize( {
            :sitemapWidget => sitemapSlider,
            :state => _statusText,
            :isActionable => true
        } );
    }

    // Updates the menu item
    // This function is called when new data comes in from the
    // sitemap polling
    public function update( sitemapWidget as SitemapWidget ) as Void {
        BaseSitemapMenuItem.update( sitemapWidget );
        if( ! ( sitemapWidget instanceof SitemapSlider ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapWidget.label + "' was passed into SliderMenuItem but is of a different type" );
        }
        _sitemapSlider = sitemapWidget;
        _statusText.setText( sitemapWidget.numericState.toString() + sitemapWidget.unit );
    }

    // When the menu item is selected, the CustomPicker is initialized
    // and pushed to the view stack
    public function onSelect() as Void {
        if( _commandRequest != null ) {
            ViewHandler.pushView(
                new CustomPicker( 
                    getLabel(),
                    new SliderPickerFactory( self )
                ),
                new SliderPickerDelegate( self ),
                WatchUi.SLIDE_LEFT
            );
        }
    }

    // This function is called during a command request to identify
    // the target item that the command should be sent to.
    public function getItemName() as String {
        return _sitemapSlider.item.name;
    }

    // The Picker uses this function to update the state
    // It stores the new state and sends a command
    // request to change it on the server
    public function updateState( newState as Number ) as Void {
        if( _commandRequest == null ) {
            throw new GeneralException( "SliderMenuItem: state update not possible because command support is not active" );
        }
        // Store the new state in the Sitemap Slider object
        _sitemapSlider.numericState = newState;
        _sitemapSlider.item.state = newState.toString();
        
        // Update the status
        _statusText.setText( _sitemapSlider.numericState.toString() + _sitemapSlider.unit );
        
        // And send the command
        ( _commandRequest as BaseCommandRequest ).sendCommand( _sitemapSlider.item.state );
    }

    // Nothing to be done, but needed to fullfil the delegate interface
    function onCommandComplete() as Void {
    }

    // Exceptions from the command request are handed
    // over to the ExceptionHandler
    function onException( ex as Exception ) as Void {
        ExceptionHandler.handleException( ex );
    }
}