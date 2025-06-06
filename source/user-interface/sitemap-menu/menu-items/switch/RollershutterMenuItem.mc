import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Menu item for Switch elements of type "Rollershutter".
 * Displays the current state as text, applying any available mappings and state descriptions.
 * When selected, opens a dedicated full-screen view with controls for "Up", "Down", and "Stop".
 */
class RollershutterMenuItem extends BaseWidgetMenuItem {

    // Returns true if the given widget matches the type handled by this menu item.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean {
        return 
            sitemapWidget instanceof SitemapSwitch
            && sitemapWidget.item.type.equals( "Rollershutter" )
            && sitemapWidget.item.hasState();
    }

    // For sending commands
    private var _commandRequest as BaseCommandRequest?;

    // The full-screen view is instantiated only when the
    // menu item is selected
    private var _rollershutterView as RollershutterView?;

    // The SitemapSwitch is retained and updated when the
    // delegate sends a command, to communicate the change
    // to the view
    private var _sitemapSwitch as SitemapSwitch;

    // The Drawable for the state
    private var _stateDrawable as Text;

    // Constructor
    // Initializes the BaseCommandRequest used for changing the state,
    // the Drawable for the displayed status and the superclass
    public function initialize( 
        sitemapSwitch as SitemapSwitch,
        parent as BasePageMenu 
    ) {
        _sitemapSwitch = sitemapSwitch;
        
        _commandRequest = BaseCommandRequest.get( self );

        // The status shown in the menu item
        _stateDrawable = new StatusText( sitemapSwitch.transformedState );
        
        BaseWidgetMenuItem.initialize( {
                :sitemapWidget => sitemapSwitch,
                :state => _stateDrawable,
                :isActionable => true,
                :parent => parent
            }
        );
    }

    // This function is called during a command request to identify
    // the target item that the command should be sent to.
    public function getItemName() as String {
        return _sitemapSwitch.item.name;
    }

    // Nothing to be done, but needed to fullfil the delegate interface
    function onCommandComplete() as Void {
    }

    // Exceptions from the command request are handed
    // over to the ExceptionHandler
    function onException( ex as Exception ) as Void {
        ExceptionHandler.handleException( ex );
    }

    // Called by the delegate when the view is exited
    function onReturn() as Void {
        _rollershutterView = null;
    }

    // When the menu item is selected, the full-screen 
    // view is initialized and pushed to the view stack
    public function onSelect() as Boolean {
        // First we see if the base class handles the event ...
        if( ! BaseWidgetMenuItem.onSelect() ) {
            // ... if not, and we do have a command request, then we
            // initialize a new full-screen view and display it
            if( _commandRequest != null ) {
                _rollershutterView = new RollershutterView( _sitemapSwitch );
                ViewHandler.pushView(
                    _rollershutterView,
                    new RollershutterDelegate( self ),
                    WatchUi.SLIDE_LEFT
                );
            }
        }
        return true;
    }

    // The delegate uses this function to update the state
    // It stores the new state and sends a command
    // request to change it on the server
    public function sendCommand( newState as String ) as Void {
        if( _commandRequest == null ) {
            throw new GeneralException( "RollershutterMenuItem: state update not possible because command support is not active" );
        }

        // First, we store the new state ...
        _sitemapSwitch.updateState( newState );

        // ... and if still open, request an update of the
        // full-screen view, which is linked to the element
        // updated above ...
        if( _rollershutterView != null ) {
            _rollershutterView.requestUpdate();
        }

        // ... and update the state Drawable ...
        _stateDrawable.setText( _sitemapSwitch.transformedState );
        
        // ... and finally send the command.
        ( _commandRequest as BaseCommandRequest ).sendCommand( newState );
    }

    // Updates the menu item
    // This function is called when new data comes in from the
    // sitemap polling
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void {
        BaseWidgetMenuItem.updateWidget( sitemapWidget );
        
        // Verify that the passed in element is of the right type
        if( ! ( sitemapWidget instanceof SitemapSwitch ) ) {
            throw new GeneralException( "Sitemap element '" + sitemapWidget.label + "' was passed into RollershutterMenuItem but is of a different type" );
        }
        
        // Store the new widget
        _sitemapSwitch = sitemapWidget;
        
        // Update the state drawable
        _stateDrawable.setText( sitemapWidget.transformedState );
        
        // If the view is currently open, we update it as well      
        if( _rollershutterView != null ) {
            _rollershutterView.updateWidget( sitemapWidget );
        }
    }
}