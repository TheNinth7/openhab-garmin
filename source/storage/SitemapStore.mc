import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application;

/*
    The SitemapStore stores the latest JSON and persists it in storage
    when the application is ended. This happens both in glance and widget
    and helps the widget startup faster and display current data.

    On older devices the glance may not have enough memory to read the JSON
    from storage or receive it via web request. On those devices we still want
    to display the sitemap label in the glance, and therefore the label is
    stored separately.
*/
(:glance)
class SitemapStore  {
    // Storage field names
    private static const STORAGE_JSON as String = "json";   
    private static const STORAGE_LABEL as String = "sitemapLabel";   

    // Current json/label
    private static var _json as JsonObject?;
    private static var _label as String?;

    // Return the SitemapHomepage instance representing the current JSON
    public static function getHomepage() as SitemapHomepage? {
        if( _json == null ) {
            _json = Storage.getValue( STORAGE_JSON ) as JsonObject?;
        }
        if( _json != null ) {
            return new SitemapHomepage( _json );
        }
        return null;
    }

    // Return the current label
    public static function getLabel() as String? {
        if( _label == null ) {
            _label = Storage.getValue( STORAGE_LABEL ) as String?;
        }
        return _label;
    }

    // Other accessors
    public static function updateJson( json as JsonObject ) as Void {
        _json = json;
    }
    public static function updateLabel( label as String ) as Void {
        _label = label;
    }
    public static function deleteJson() as Void {
        Storage.deleteValue( STORAGE_JSON );
    }

    // Persist the current data to storage
    // This function is called by OHApp wenn the application is stopped
    public static function persist() as Void {
        if( _json != null ) {
            Storage.setValue( STORAGE_JSON, _json as Dictionary<Application.PropertyKeyType, Application.PropertyValueType> );
        }
        if( _label != null ) {
            Storage.setValue( STORAGE_LABEL, _label );
        }
    }
}