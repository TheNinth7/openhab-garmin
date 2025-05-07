import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

class NativeCommandRequest extends BaseRequest {
    private var _url as String;
    private var _item as CommandMenuItemInterface;

    public function initialize( item as CommandMenuItemInterface ) {
        BaseRequest.initialize();
        _item = item;
        _url = AppSettings.getUrl() + "items/" + item.getItemName();
        setOption( :method, Communications.HTTP_REQUEST_METHOD_POST );
        setOption( :responseType, Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN );
        setHeader( "Content-Type", Communications.REQUEST_CONTENT_TYPE_JSON );
    }

    public function sendCommand( cmd as String ) as Void {
        var parameters = {
            "value" => cmd
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