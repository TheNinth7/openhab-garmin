import Toybox.Lang;
import Toybox.Communications;
import Toybox.PersistedContent;
import Toybox.WatchUi;

class BaseCommandRequest extends BaseRequest {
    private var _url as String;
    private var _item as CommandMenuItemInterface;

    public function initialize( item as CommandMenuItemInterface, url as String, method as Communications.HttpRequestMethod ) {
        BaseRequest.initialize( method );
        _item = item;
        _url = url;
        setHeader( "Content-Type", Communications.REQUEST_CONTENT_TYPE_JSON );
    }

    public function makeWebRequest( parameters as Dictionary<Object, Object>? ) as Void {
        Communications.makeWebRequest( _url, parameters, getBaseOptions(), method( :onReceive ) );
    }

    public function onReceive( responseCode as Number, data as Dictionary<String,Object?> or String or PersistedContent.Iterator or Null ) as Void {
        try {
            checkResponseCode( responseCode, CommunicationException.EX_SOURCE_COMMAND );
            _item.onCommandComplete();
        } catch( ex ) {
            _item.onException( ex );
            ExceptionHandler.handleException( ex );
        }
    }
}   