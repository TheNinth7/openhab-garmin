import Toybox.Lang;
import Toybox.Application.Properties;

class AppSettings {
    private static var _instance as AppSettings?;
    
    private static function getInstance() as AppSettings {
        if( _instance == null ) {
            _instance = new AppSettings();
        }
        return _instance as AppSettings;
    }

    private const URL_PREFIX = "url_";
    private const SITEMAP_PREFIX = "sitemap_";

    public var url as String;
    public var sitemap as String;
    private var _index as Number = 0;
    
    private function initialize() {
        url = getString( URL_PREFIX + _index, "Configuration: URL is missing!" );
        sitemap = getString( SITEMAP_PREFIX + _index, "Configuration: sitemap is missing!" );
    }

    public static function getUrl() as String {
        return getInstance().url;
    }

    public static function getSitemap() as String {
        return getInstance().sitemap;
    }

    private function getString( name as String, errorMessage as String ) as String {
        var value = Properties.getValue( name ) as String;
        if( value.equals( "" ) ) {
            throw new ConfigException( errorMessage );
        }
        return value;
    }
}