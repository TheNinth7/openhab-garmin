import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application;

/*
    The SitemapErrorCountStore keeps track of communication errors
    related to the SitemapRequest.
    Non-fatal communication errors related to the sitemap turn fatal
    after a certain amount of occurences, and this store keeps track
    of such occurances across glance and widget.
    Purpose is that if the glance already runs into the threshold, the
    widget should display an error right away on startup.

    This class is a static singleton for easy access.
*/
(:glance)
class SitemapErrorCountStore  {

    // The field name used in storage
    private static const STORAGE_ERROR_COUNT as String = "errorCount";

    // The error count
    private static var _errorCount as Number? = null;

    // Returns the error count
    public static function get() as Number {
        // If there is no value yet, we read it from storage
        // and if there is none there either we set it to 0.
        if( _errorCount == null ) {
            _errorCount = Storage.getValue( STORAGE_ERROR_COUNT ) as Number?;
            if( _errorCount == null ) {
                _errorCount = 0;
            }
        }
        return _errorCount as Number;
    }

    // Increment the error count by 1
    public static function increment() as Void {
        _errorCount = get() + 1;
    }

    // Reset the error count to 0
    public static function reset() as Void {
        _errorCount = 0;
    }

    // Persist the error count into storage, called by OHApp when
    // the application is stopped    
    public static function persist() as Void {
        if( _errorCount != null ) {
            Logger.debug( "SitemapErrorCountStore.persist: errorCount=" + _errorCount );
            Storage.setValue( STORAGE_ERROR_COUNT, _errorCount );
        }
    }
}