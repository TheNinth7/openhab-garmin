import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

/*
 * The `ExceptionHandler` should be used throughout the widget to handle unexpected exceptions.
 *
 * Its behavior includes:
 * - Showing a toast notification for non-fatal sitemap communication errors.
 * - Displaying a full-screen error view if non-fatal sitemap errors persist for a certain period, 
 *   even if they differ across attempts.
 * - Showing a toast notification for command communication errors, as these typically affect only 
 *   individual items and do not compromise the entire sitemap view.
 * - Displaying a full-screen error view immediately for all other errors.
 *
 * Full-screen errors are managed by `ErrorViewHandler`, while toast notifications are handled by `ToastHandler`.
 */
public class ExceptionHandler {
    /*
    * If a non-fatal sitemap communication error persists longer than the specified duration, 
    * a full-screen error view will be displayed.
    */
    private static const SITEMAP_ERROR_FATAL_TIME = 10000;

    /*
    * Calculates how many non-fatal errors are allowed before the error is considered fatal.
    *
    * The calculation is based on:
    * - The duration defined by `SITEMAP_ERROR_FATAL_TIME`
    * - The polling interval for errors, as calculated in `BaseSitemapRequest`
    *
    * The timer starts when the first non-fatal error occurs.
    */
    private static const SITEMAP_ERROR_FATAL_ERROR_COUNT = 
        1 + // the polling interval counts from the time the first error occured
        Math.round( 
            SITEMAP_ERROR_FATAL_TIME 
            / BaseSitemapRequest.SITEMAP_ERROR_POLLING_INTERVAL 
        ).toNumber();

    // Determines whether the current error count is still below the fatal error threshold.
    public static function errorCountIsNotYetFatal() as Boolean {
        return SitemapErrorCountStore.get() < SITEMAP_ERROR_FATAL_ERROR_COUNT;
    }

    /*
    * Note on STARTUP EXCEPTIONS:
    *
    * Most exceptions during startup are handled directly by `OHApp`, which starts 
    * into an error view if needed. However, startup also triggers the first sitemap request. 
    * If this request fails immediately (e.g., with error -104: no phone), `onReceive()` 
    * may be called before any view is ready to display the error.
    *
    * To handle this, such exceptions are stored by `handleException()` and later consumed 
    * by one of the two views that may be loaded initially: `LoadingView` or `HomepageMenu`.
    *
    * The stored value is a tuple consisting of the exception itself and a flag indicating 
    * whether it should already be treated as fatal.
    *
    * NOTE: The "non-fatal" flag in this tuple is not necessarily the same as `exception.isFatal()`.
    * An exception might not be inherently fatal, but may still be treated as such 
    * if it has persisted beyond a configured threshold.
    */
    private static var _startupException as [Exception, Boolean]?;
    
    public static function handleException( ex as Exception ) as Void {
        Logger.debugException( ex );

        // Increment the counter of sitemap-related communication errors
        if( ex instanceof CommunicationBaseException 
            && ex.isFrom( CommunicationBaseException.EX_SOURCE_SITEMAP ) )
        {
            SitemapErrorCountStore.increment();
        }
        
        // Logger.debug( "ExceptionHandler: exception #" + SitemapErrorCountStore.get() + "/" + SITEMAP_ERROR_FATAL_ERROR_COUNT );
        
        /*
        * A toast notification will be shown under the following conditions:
        * - For all non-sitemap (i.e., command) communication errors.
        * - For sitemap errors that are not fatal in themselves and 
        *   the fatal error count threshold has not yet been reached.
        * - Only if the current view has indicated to the `ToastHandler` that toasts are allowed.
        *
        * In all other cases, a full-screen error view is displayed instead.
        */
        if( ex instanceof CommunicationBaseException 
            &&  ( !ex.isFrom( CommunicationBaseException.EX_SOURCE_SITEMAP )
                || errorCountIsNotYetFatal() )
            && !ex.isFatal()
            && ToastHandler.useToasts() ) 
            {
            // Logger.debug( "ExceptionHandler: non-fatal error: " + ex.getToastMessage().toUpper() );
            
            // If there is no view yet, the exception is stored
            // as startup exception, otherwise the toast will be shown
            if( WatchUi.getCurrentView()[0] == null ) {
                // Logger.debug( "ExceptionHandler: storing non-fatal startup exception" );
                _startupException = [ex, false];
            } else {
                ToastHandler.showWarning( ex.getToastMessage() );
            }
        } else {
            Logger.debug( "ExceptionHandler: fatal error" );
            
            /*
            * Fatal errors clear the stored JSON.
            * This prevents stale data from being shown if the app is restarted, 
            * which would otherwise display outdated content until the error reoccurs.
            */
            SitemapStore.deleteJson();
            
            /*
            * If no view is currently active, the exception is stored as a startup exception.
            * Otherwise, the full-screen error view is shown immediately.
            */
            if( WatchUi.getCurrentView()[0] == null ) {
                Logger.debug( "ExceptionHandler: storing fatal startup exception" );
                _startupException = [ex, true];
            } else {
                ErrorViewHandler.showOrUpdateErrorView( ex );
            }
        }
    }

    /*
    * This function must be called by views initially loaded by `OHApp`, 
    * such as `LoadingView` and `HomepageMenu`.
    *
    * Depending on the type of exception that occurred during startup, 
    * it will display either a toast notification or a full-screen error view.
    */
    public static function consumeStartupException( useToast as Boolean ) as ErrorView? {
        if( _startupException != null ) {
            var startupException = _startupException;
            _startupException = null;
            var ex = startupException[0];
            
            /*
            * A toast is shown if the startup exception is a non-fatal 
            * communication error and the calling view has enabled toast notifications.
            */
            if( useToast && !startupException[1] && ex instanceof CommunicationBaseException ) {
                ToastHandler.showWarning( ex.getToastMessage() );
            } else {
                return ErrorViewHandler.createOrUpdateErrorView( ex );
            }
        }
        return null;
    }
}