import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application;

(:glance)
class SitemapStore  {
    private static const STORAGE_JSON as String = "json";

    private static var _json as JsonObject?;

    public static function get() as SitemapHomepage? {
        if( _json == null ) {
            _json = Storage.getValue( STORAGE_JSON ) as JsonObject?;
        }
        if( _json != null ) {
            return new SitemapHomepage( _json );
        }
        return null;
    }

    public static function update( json as JsonObject ) as Void {
        _json = json;
    }

    public static function delete() as Void {
        Storage.deleteValue( STORAGE_JSON );
    }

    public static function persist() as Void {
        if( _json != null ) {
            Storage.setValue( STORAGE_JSON, _json as Dictionary<Application.PropertyKeyType, Application.PropertyValueType> );
        }
    }
}