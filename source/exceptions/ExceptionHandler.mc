import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

public class ExceptionHandler {
    private static const FATAL_SITEMAP_ERROR_TIME = 10000;
    private static const FATAL_SITEMAP_ERROR_COUNT = Math.round( FATAL_SITEMAP_ERROR_TIME / AppSettings.getPollingInterval() ).toNumber();

    private static var _useToasts as Boolean = false;
    public static function setUseToasts( useToasts as Boolean ) as Void { 
        _useToasts = useToasts; 
    }

    public static function handleException( ex as Exception ) as Void {
        Logger.debugException( ex );
        
        if( ex instanceof CommunicationBaseException 
            && ex.isFrom( CommunicationBaseException.EX_SOURCE_SITEMAP ) )
            {
                SitemapErrorCountStore.increment();
            }
        
        Logger.debug( "ExceptionHandler: " + SitemapErrorCountStore.get() + "/" + FATAL_SITEMAP_ERROR_COUNT );
        if( ex instanceof CommunicationBaseException 
            &&  ( !ex.isFrom( CommunicationBaseException.EX_SOURCE_SITEMAP )
                  || SitemapErrorCountStore.get() < FATAL_SITEMAP_ERROR_COUNT )
            && !ex.isFatal()
            && _useToasts ) 
            {
            Logger.debug( "ExceptionHandler: showing toast" );
 
            WatchUi.showToast( 
                ex.getToastMessage().toUpper(), 
                { :icon => Rez.Drawables.iconWarning } );
        } else {
            Logger.debug( "ExceptionHandler: showing error view" );
            SitemapStore.delete();
            ViewHandler.showOrUpdateErrorView( ex );
            _useToasts = false;
        }
    }
}