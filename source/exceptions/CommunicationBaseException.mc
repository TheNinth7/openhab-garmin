import Toybox.Lang;

/*
 * Base class for all communication-related exceptions
 * (e.g., errors arising from web requests).
 */
 (:glance)
class CommunicationBaseException extends Exception {
    /*
    * Communication exceptions originate from either sitemap polling
    * or command requests.
    */
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

    /*
    * This applies only to sitemap-related exceptions:
    * - Fatal polling errors trigger an immediate full-screen error.
    * - Non-fatal polling errors first show a toast notification.
    *   If they persist past the configured threshold, a full-screen error is displayed.
    */
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

    /*
    * Subclasses must implement methods to provide:
    * - A detailed full-screen error message.
    * - A concise toast notification message.
    */
    public function getErrorMessage() as String or Null {
        throw new AbstractMethodException( "CommunicationBaseException.getErrorMessage" );
    }
    public function getToastMessage() as String {
        throw new AbstractMethodException( "CommunicationBaseException.getToastMessage" );
    }

    // Subclasses should override this to decide if the exception they represent should
    // be suppressed if the "suppress empty responses" option is enabled in settings.
    // This is primarily for myopenhab.org, which occasionally returns empty responses.
    // Depending on the SDK and phone OS, this may result in a -400 CommunicationException
    // or an UnexpectedResponseException for a null result. This method allows handling 
    // both cases consistently.
    public function suppressAsEmptyResponse() as Boolean {
        return false;
    }
}