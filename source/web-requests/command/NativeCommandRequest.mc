import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

/*
    Command request for sending commands to the 
    native REST API of openHAB. 
    At the time of writing this native REST API is still under 
    development. While there currently is a REST API for sending
    commands to items, it requires the command to be send as RAW 
    content of the request, which is not supported by the Garmin SDK. 
    Therefore openHAB will be enhanced with a request accepting JSON 
    as payload.
*/
class NativeCommandRequest extends BaseCommandRequest {

     // Constructor
     // @param item - the menu item to be associated with this command
    public function initialize( item as CommandMenuItemInterface ) {
        BaseCommandRequest.initialize( 
            item, 
            AppSettings.getUrl() + "rest/items/" + item.getItemName(),
            Communications.HTTP_REQUEST_METHOD_POST 
        );
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN );
        setHeader( "Content-Type", Communications.REQUEST_CONTENT_TYPE_JSON );
    }

    // Sending a command
    // @param cmd - the command value, e.g. "ON" or "OFF"
    public function sendCommand( cmd as String ) as Void {
        makeWebRequest( { "value" => cmd } );
    }

}