import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application;

(:glance)
class SitemapErrorCountStore  {
    private static const STORAGE_ERROR_COUNT as String = "errorCount";

    private static var _errorCount as Number? = null;

    public static function get() as Number {
        if( _errorCount == null ) {
            _errorCount = Storage.getValue( STORAGE_ERROR_COUNT ) as Number?;
            if( _errorCount == null ) {
                _errorCount = 0;
            }
        }
        return _errorCount as Number;
    }

    public static function increment() as Void {
        _errorCount = get() + 1;
    }

    public static function reset() as Void {
        _errorCount = 0;
    }

    public static function persist() as Void {
        if( _errorCount != null ) {
            Logger.debug( "SitemapErrorCountStore.persist: errorCount=" + _errorCount );
            Storage.setValue( STORAGE_ERROR_COUNT, _errorCount );
        }
    }
}