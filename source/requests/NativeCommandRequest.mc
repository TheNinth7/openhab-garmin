import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

class NativeCommandRequest extends BaseCommandRequest {

    public function initialize( item as CommandMenuItemInterface ) {
        BaseCommandRequest.initialize( 
            item, 
            AppSettings.getUrl() + "rest/items/" + item.getItemName(),
            Communications.HTTP_REQUEST_METHOD_POST 
        );
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN );
        setHeader( "Content-Type", Communications.REQUEST_CONTENT_TYPE_JSON );
    }

    public function sendCommand( cmd as String ) as Void {
        makeWebRequest( { "value" => cmd } );
    }

}