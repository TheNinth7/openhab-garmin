import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application;

(:glance)
class SitemapStore  {
    private static const STORAGE_JSON as String = "json";   
    private static const STORAGE_LABEL as String = "sitemapLabel";   

    private static var _json as JsonObject?;
    private static var _label as String?;

    public static function getHomepage() as SitemapHomepage? {
        if( _json == null ) {
            _json = Storage.getValue( STORAGE_JSON ) as JsonObject?;
        }
        if( _json != null ) {
            return new SitemapHomepage( _json );
        }
        return null;
    }

    public static function getLabel() as String? {
        if( _label == null ) {
            _label = Storage.getValue( STORAGE_LABEL ) as String?;
        }
        return _label;
    }

    public static function updateJson( json as JsonObject ) as Void {
        _json = json;
    }

    public static function updateLabel( label as String ) as Void {
        _label = label;
    }

    public static function delete() as Void {
        Storage.deleteValue( STORAGE_JSON );
        Storage.deleteValue( STORAGE_LABEL );
    }

    public static function persist() as Void {
        if( _json != null ) {
            Storage.setValue( STORAGE_JSON, _json as Dictionary<Application.PropertyKeyType, Application.PropertyValueType> );
        }
        if( _label != null ) {
            Storage.setValue( STORAGE_LABEL, _label );
        }
    }
}