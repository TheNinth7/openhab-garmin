import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

/*
    The ExceptionHandler shall be used anywhere in the widget when an unexpected
    exception occurs.
    It will:
    - For non-fatal sitemap communication errors show a toast notification.
    - If a non-fatal sitemap communication error persisted over a certain time,
      show a full-screen error view. This applies also if there are different
      subsequent non-fatal errors over that time 
    - For any command communication errors show a toast notification, since those do not
      compromise the sitemap view and may just affect a single item.
    - For all other errors, a full screen error view will be shown immediately.
    For full-screen errors the ErrorViewHandler is used, for toasts the ToastHandler
*/ 
public class ExceptionHandler {
    // If a non-fatal sitemap communication error persists for longer than
    // the specified time, a full-screen error view will be shown
    private static const SITEMAP_ERROR_FATAL_TIME = 10000;

    /*
        Calculate the number of non-fatal errors that are allowed to occur,
        before the error is treated as fatal
        The calculation is based on:
        - the time specified in SITEMAP_ERROR_FATAL_TIME
        - the polling interval for errors calculated in BaseSitemapRequest
        The time starts when the first error occurs.
    */
    private static const SITEMAP_ERROR_FATAL_ERROR_COUNT = 
        1 + // the polling interval counts from the time the first error occured
        Math.round( 
            SITEMAP_ERROR_FATAL_TIME 
            / BaseSitemapRequest.SITEMAP_ERROR_POLLING_INTERVAL 
        ).toNumber();

    // Determines whether the error count is still under the
    // fatal error count
    public static function errorCountIsNotYetFatal() as Boolean {
        return SitemapErrorCountStore.get() < SITEMAP_ERROR_FATAL_ERROR_COUNT;
    }

    /*
    Note on STARTUP EXCEPTIONS
    Most exceptions during startup are handled directly in OHApp, which
    starts into an error view. However, the startup also starts the
    first sitemap request. If this leads to an immediate error (such as -104
    no phone), then onReceive() may be called with this error but is not
    able to show a view yet. Therefore these exceptions are stored here
    by handleException() and then consumed by the two views that may 
    be loaded initially (LoadingView and HomepageMenu)
    The value is a tuple, made of the exception itself, and
    whether it is already fatal.
    NOTE: the non-fatal flag in the startup exception is not 
    necessarily the same as the isFatal() of the exception itself
    isFatal() may be false, but it may still be considered fatal
    if the error occured over a certain amount of time
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
        
        // Under certain conditions, a toast will be displayed
        // These are:
        // For all non-sitemap (=command) communication errors
        // For sitemap errors if they are not fatal in itself and if the
        // fatal error count has not yet been reached
        // And only if the current view has indicated to the ToastHandler
        // that toasts shall be used

        // Under all other conditions, a full-screen error is displayed.

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
            
            // Fatal errors clear the JSON
            // Otherwise the app may be restarted and initially the 
            // stale JSON would be displayed until the error occurs again.
            SitemapStore.deleteJson();
            
            // If there is no view yet, the exception is stored
            // as startup exception, otherwise the error view will be shown
            if( WatchUi.getCurrentView()[0] == null ) {
                Logger.debug( "ExceptionHandler: storing fatal startup exception" );
                _startupException = [ex, true];
            } else {
                ErrorViewHandler.showOrUpdateErrorView( ex );
            }
        }
    }

    // This function must be called by views that are loaded initially
    // by OHApp, i.e. LoadingView and HomepageMenu
    // Depending on the nature of the exception that occured during
    // startup, either a toast or the full-screen error view
    // is shown
    public static function consumeStartupException( useToast as Boolean ) as ErrorView? {
        if( _startupException != null ) {
            var startupException = _startupException;
            _startupException = null;
            var ex = startupException[0];
            
            // A toast is whon if the startup exception is a non-fatal
            // communication exception and toasts are enabled by the 
            // calling view
            if( useToast && !startupException[1] && ex instanceof CommunicationBaseException ) {
                ToastHandler.showWarning( ex.getToastMessage() );
            } else {
                return ErrorViewHandler.createOrUpdateErrorView( ex );
            }
        }
        return null;
    }
}