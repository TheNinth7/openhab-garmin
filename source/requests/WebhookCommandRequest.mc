import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

class WebhookCommandRequest extends BaseRequest {
    private var _url as String;
    private var _item as CommandMenuItemInterface;  

    public function initialize( item as CommandMenuItemInterface ) {
        BaseRequest.initialize();
        _url = AppSettings.getUrl() + "webhook/" + AppSettings.getWebhook();
        _item = item;
    }

    public function sendCommand( cmd as String ) as Void {
        var parameters = {
            "action" => "sendCommand",
            "itemName" => _item.getItemName(),
            "command" => cmd
        };
        Communications.makeWebRequest( _url, parameters, getBaseOptions(), method( :onReceive ) );
    }

    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        try {
            checkResponseCode( responseCode, CommunicationException.EX_SOURCE_COMMAND );
            _item.onCommandComplete();
        } catch( ex ) {
            ExceptionHandler.handleException( ex );            
        }
    }
}