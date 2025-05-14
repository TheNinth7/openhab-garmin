import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

/*
    Base class for command requests
    Command requests are used to issue commands to openHAB items
    There are two derivates of this class, one for the custom Webhook,
    and one for the native REST APIs
    This class 
    - holds the menu item that this request is associated with
      - the menu item has to implement the CommandMenuItemInterface,
        which prescribes event handlers for processing the result of the command
    - holds the URL for the request
    - provides a function for making the request, to be used by derivates
    - processes the response and calls the event handler of the item
*/

// Interface to be implemented by menu items that issue commands.
// Defines the functions and callbacks required for interaction 
// of the command request with the menu item.
typedef CommandMenuItemInterface as interface {
    function getItemName() as String;
    function onCommandComplete() as Void;
    function onException( ex as Exception ) as Void;
};

// Interface to be implemented by subclasses representing concrete 
// command request implementations. Defines the methods required for 
// interaction of the menu item with the command request.
typedef CommandRequestInterface as interface {
    function sendCommand( cmd as String ) as Void;
};

class BaseCommandRequest extends BaseRequest {
    private var _url as String;
    private var _item as CommandMenuItemInterface;

    // Constructor
    protected function initialize( item as CommandMenuItemInterface, url as String, method as Communications.HttpRequestMethod ) {
        BaseRequest.initialize( method );
        _item = item;
        _url = url;
    }

    // Triggers the web request
    // @param parameters - options for the web request, as per Communication.makeWebRequest
    protected function makeWebRequest( parameters as Dictionary<Object, Object>? ) as Void {
        // Logger.debug( "BaseCommandRequest: makeWebRequest to " + _url );
        try {
            WidgetSitemapRequest.get().stop();
            Communications.makeWebRequest( _url, parameters, getBaseOptions(), method( :onReceive ) );
        } catch( ex ) {
            WidgetSitemapRequest.get().start();
            throw ex;
        }
    }

    // Processes the response to the web request
    // If the request was successful, onCommandComplete() is called
    // If there was an error, onException() is being called
    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        try {
            WidgetSitemapRequest.get().start();
            checkResponseCode( responseCode, CommunicationException.EX_SOURCE_COMMAND );
            _item.onCommandComplete();
        } catch( ex ) {
            _item.onException( ex );
            ExceptionHandler.handleException( ex );
        }
    }
}   