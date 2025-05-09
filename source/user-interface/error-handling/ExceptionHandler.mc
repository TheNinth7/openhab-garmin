import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

public class ExceptionHandler {
    private static const FATAL_SITEMAP_ERROR_TIME = 10000;
    private static const FATAL_SITEMAP_ERROR_COUNT = Math.round( FATAL_SITEMAP_ERROR_TIME / AppSettings.getPollingInterval() ).toNumber();

    public static function errorCountIsNotYetFatal() as Boolean {
        return SitemapErrorCountStore.get() < FATAL_SITEMAP_ERROR_COUNT;
    }

    private static var _startupException as [Exception, Boolean]?;
    public static function consumeStartupException( useToast as Boolean ) as ErrorView? {
        if( _startupException != null ) {
            var startupException = _startupException;
            _startupException = null;
            var ex = startupException[0];
            if( useToast && !startupException[1] && ex instanceof CommunicationBaseException ) {
                ToastHandler.showWarning( ex.getToastMessage() );
            } else {
                return ErrorViewHandler.createOrUpdateErrorView( ex );
            }
        }
        return null;
    }
    
    public static function handleException( ex as Exception ) as Void {
        Logger.debugException( ex );

        if( ex instanceof CommunicationBaseException 
            && ex.isFrom( CommunicationBaseException.EX_SOURCE_SITEMAP ) )
        {
            SitemapErrorCountStore.increment();
        }
        
        Logger.debug( "ExceptionHandler: exception #" + SitemapErrorCountStore.get() + "/" + FATAL_SITEMAP_ERROR_COUNT );
        if( ex instanceof CommunicationBaseException 
            &&  ( !ex.isFrom( CommunicationBaseException.EX_SOURCE_SITEMAP )
                || errorCountIsNotYetFatal() )
            && !ex.isFatal()
            && ToastHandler.useToasts() ) 
            {
            Logger.debug( "ExceptionHandler: non-fatal error: " + ex.getToastMessage().toUpper() );
            if( WatchUi.getCurrentView()[0] == null ) {
                Logger.debug( "ExceptionHandler: storing non-fatal startup exception" );
                _startupException = [ex, false];
            } else {
                ToastHandler.showWarning( ex.getToastMessage() );
            }
        } else {
            Logger.debug( "ExceptionHandler: fatal error" );
            SitemapStore.deleteJson();
            if( WatchUi.getCurrentView()[0] == null ) {
                Logger.debug( "ExceptionHandler: storing fatal startup exception" );
                _startupException = [ex, true];
            } else {
                ErrorViewHandler.showOrUpdateErrorView( ex );
            }
        }
    }
}