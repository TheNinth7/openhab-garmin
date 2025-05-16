import Toybox.Lang;
import Toybox.WatchUi;

/*
 * This menu item represents the Slider widget in the app.
 * It displays the current slider value and, when selected,
 * opens a separate view (a Picker implementation) that allows
 * the user to adjust the value.
 *
 * The Picker respects sitemap settings for minValue, maxValue, and step.
 * It also supports 'releaseOnly' mode: if enabled, the item state is updated
 * only after the user confirms their selection. If disabled, the state updates
 * continuously as the user scrolls through values.
 */
class SliderMenuItem extends BaseSitemapMenuItem {

    // Returns true if the given sitemap element matches the type handled by this menu item.
    public static function isMyType( sitemapElement as SitemapElement ) as Boolean {
        return 
            sitemapElement instanceof SitemapSlider;
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
        _statusText = new Text( {
            :text => sitemapSlider.sliderState.toString() + sitemapSlider.unit,
            :font => Constants.UI_MENU_ITEM_FONTS[0],
            :color => Constants.UI_COLOR_ACTIONABLE,
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR
        } );
        
        BaseSitemapMenuItem.initialize( {
            :id => sitemapSlider.id,
            :label => sitemapSlider.label,
            :status => _statusText
        } );
    }

    // Updates the menu item
    // This function is called when new data comes in from the
    // sitemap polling
    public function update( sitemapElement as SitemapElement ) as Boolean {
        if( ! ( sitemapElement instanceof SitemapSlider ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapElement.label + "' was passed into SliderMenuItem but is of a different type" );
        }
        _sitemapSlider = sitemapElement;
        _statusText.setText( sitemapElement.sliderState.toString() + sitemapElement.unit );
        setLabel( sitemapElement.label );
        return true;
    }

    // When the menu item is selected, the Picker is initialized
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

/*
            ViewHandler.pushView(
                new SliderPicker( 
                    getLabel(),
                    new SliderPickerFactory( self ) 
                ),
                new SliderPickerDelegate( self ),
                WatchUi.SLIDE_LEFT
            );
*/
        }
    }

    // This function is called during a command request to identify
    // the target item that the command should be sent to.
    public function getItemName() as String {
        return _sitemapSlider.itemName;
    }

    // The Picker uses this function to update the state
    // It stores the new state and sends a command
    // request to change it on the server
    public function updateState( newState as Number ) as Void {
        if( _commandRequest == null ) {
            throw new GeneralException( "SliderMenuItem: state update not possible because command support is not active" );
        }
        // Store the new state in the Sitemap Slider object
        _sitemapSlider.sliderState = newState;
        _sitemapSlider.normalizedItemState = newState.toString();
        
        // Update the status
        _statusText.setText( _sitemapSlider.sliderState.toString() + _sitemapSlider.unit );
        
        // And send the command
        ( _commandRequest as BaseCommandRequest ).sendCommand( _sitemapSlider.normalizedItemState );
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