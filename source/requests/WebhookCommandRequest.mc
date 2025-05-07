import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

class WebhookCommandRequest extends BaseCommandRequest {
    private var _parameters as Dictionary = {};

    public function initialize( item as CommandMenuItemInterface ) {
        BaseCommandRequest.initialize( 
            item, 
            AppSettings.getUrl() + "webhook/" + AppSettings.getWebhook(),
            Communications.HTTP_REQUEST_METHOD_GET 
        );
        _parameters["action"] = "sendCommand";
        _parameters["itemName"] = item.getItemName();
    }

    public function sendCommand( cmd as String ) as Void {
        _parameters["command"] = cmd;
        makeWebRequest( _parameters as Dictionary<Object,Object> );
        _parameters["command"] = null;
    }
}