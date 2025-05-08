import Toybox.Lang;

/*
    Base class for all exceptions related to communications
    (making web requests)
*/
(:glance)
class CommunicationBaseException extends Exception {
    // Sources of communications exception are
    // either polling the Sitemap or sending
    // a command
    enum Source {
        EX_SOURCE_SITEMAP,
        EX_SOURCE_COMMAND
    }

    // Name and short code of each source
    private const SOURCE_NAMES = [ "Sitemap", "Command" ];
    private const SOURCE_SHORTCODE = [ "S", "C" ];

    // The source of this instance
    private var _source as Source;

    // Only derivates of this class can be instantiated
    protected function initialize( source as Source ) {
        Exception.initialize();
        _source = source;
    }

    // Check if this instance is from a given source
    public function isFrom( source as Source ) as Boolean {
        return _source == source;
    }

    // Relevant only for exceptions with source sitemap
    // Fatal exceptions from sitemap polling lead to an 
    // immediate full-screen error while for non-fatal errors 
    // only a toast notification will be displayed. If they 
    // persist for a certain amount of time, also a full-screen 
    // error will be displayed.
    public function isFatal() as Boolean {
        return false;
    }

    // Return the name and short code of the source of this instance
    public function getSourceName() as String {
        return SOURCE_NAMES[_source];
    }
    public function getSourceShortCode() as String {
        return SOURCE_SHORTCODE[_source];
    }

    // Functions to be implemented by derivates of this class
    // providing a longer error message and a short toast message
    public function getErrorMessage() as String or Null {
        throw new AbstractMethodException( "CommunicationBaseException.getErrorMessage" );
    }
    public function getToastMessage() as String {
        throw new AbstractMethodException( "CommunicationBaseException.getToastMessage" );
    }

}