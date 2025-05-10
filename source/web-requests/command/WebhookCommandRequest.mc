import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

/*
    Command request for sending commands to the custom Webhook.
    The custom Webhook needs the Webhook HTTP binding and a custom
    thing configuration and scripted rule. See the app documentation for details.
*/
class WebhookCommandRequest extends BaseCommandRequest {

    // The parameters for the web request
    private var _parameters as Dictionary = {};

    public function initialize( item as CommandMenuItemInterface ) {
        // The custom Webhook uses GET as HTTP method,
        // and needs an ID provided in the configuration (refering to the Thing),
        // which is part of the URL
        BaseCommandRequest.initialize( 
            item, 
            AppSettings.getUrl() + "webhook/" + AppSettings.getWebhook(),
            // for hard-coding a different test endpoint: 
            // "http://net-nas-1:8080/webhook/" + AppSettings.getWebhook(),
            Communications.HTTP_REQUEST_METHOD_GET 
        );
        // action and itemName parameters are fixed
        _parameters["action"] = "sendCommand";
        _parameters["itemName"] = item.getItemName();
    }

    // The command is added to the parameters and then the
    // request is sent. Handling of the response happens in
    // the super class, since it is the same for both
    // command request implementations
    public function sendCommand( cmd as String ) as Void {
        _parameters["command"] = cmd;
        makeWebRequest( _parameters as Dictionary<Object,Object> );
        _parameters["command"] = null;
    }
}