import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

class CommandRequest extends BaseRequest {
    private var _url as String;
    private var _item as OHCommandMenuItem;

    public function initialize( item as OHCommandMenuItem ) {
        BaseRequest.initialize();
        _url = AppSettings.getUrl() + "/webhook/" + AppSettings.getWebhook();
        //_options[:responseType] = Communications.HTTP_RESPONSE_CONTENT_TYPE_URL_ENCODED;
        _item = item;
        item.getItemName();
    }

    public function sendCommand( cmd as String ) as Void {
        var parameters = {
            "action" => "sendCommand",
            "itemName" => _item.getItemName(),
            "command" => cmd
        };
        Communications.makeWebRequest( _url, parameters, _options, method( :onReceive ) );
    }

    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        try {
            checkResponseCode( responseCode );
            _item.onCommandComplete();
        } catch( ex ) {
            ExceptionHandler.handleException( ex );            
        }
    }
}