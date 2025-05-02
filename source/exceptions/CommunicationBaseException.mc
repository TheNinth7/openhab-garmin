import Toybox.Lang;

(:glance)
class CommunicationBaseException extends Exception {
    enum Source {
        EX_SOURCE_SITEMAP,
        EX_SOURCE_COMMAND
    }

    private var _source as Source;

    private const SOURCE_NAMES = [ "Sitemap", "Command" ];
    private const SOURCE_SHORTCODE = [ "S", "C" ];

    protected function initialize( source as Source ) {
        Exception.initialize();
        _source = source;
    }

    public function isFrom( source as Source ) as Boolean {
        return _source == source;
    }

    public function getSourceName() as String {
        return SOURCE_NAMES[_source];
    }

    public function getSourceShortCode() as String {
        return SOURCE_SHORTCODE[_source];
    }

    public function getErrorMessage() as String or Null {
        throw new AbstractMethodException( "CommunicationBaseException.getErrorMessage" );
    }

    public function getToastMessage() as String {
        throw new AbstractMethodException( "CommunicationBaseException.getToastMessage" );
    }

    public function isFatal() as Boolean {
        return false;
    }
}