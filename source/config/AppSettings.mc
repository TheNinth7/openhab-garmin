import Toybox.Lang;
import Toybox.Application.Properties;

(:glance)
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
    private const USER_PREFIX = "user_";
    private const PASSWORD_PREFIX = "password_";
    private const RESTAPI_PREFIX = "restapi_";
    private const WEBHOOK_PREFIX = "webhook_";
    private const INTERVAL_PREFIX = "pollingInterval_";

    public var url as String;
    public var sitemap as String;
    
    public var vNeedsBasicAuth as Boolean = false;
    public var user as String;
    public var password as String?;
    
    public var vSupportsRESTAPI as Boolean = false;
    public var vSupportsWebHook as Boolean = false;
    public var webhook as String = "";
    
    public var pollingInterval as Number;

    private var _index as Number = 0;
    
    private function initialize() {
        url = getString( URL_PREFIX + _index, "Configuration: URL is missing" );
        var lastChar = url.substring( url.length()-1, null );
        if( lastChar != null && ! lastChar.equals( "/" ) ) {
            url += "/";
        }

        sitemap = getString( SITEMAP_PREFIX + _index, "Configuration: sitemap is missing" );
        
        vSupportsRESTAPI = Properties.getValue( RESTAPI_PREFIX + _index ) as Boolean;
        if( ! vSupportsRESTAPI ) {
            webhook = Properties.getValue( WEBHOOK_PREFIX + _index ) as String;
            vSupportsWebHook = ! webhook.equals( "" );
        }
        user = Properties.getValue( USER_PREFIX + _index ) as String;
        if( ! user.equals( "" ) ) {
            vNeedsBasicAuth = true;
            password = getString( PASSWORD_PREFIX + _index, "Configuration: password is missing" );
        }
        pollingInterval = Properties.getValue( INTERVAL_PREFIX + _index ) as Number;
    }

    public static function getUrl() as String { return getInstance().url; }
    public static function getSitemap() as String { return getInstance().sitemap; }
    
    public static function supportsRestApi() as Boolean { return getInstance().vSupportsRESTAPI; }
    public static function supportsWebhook() as Boolean { return getInstance().vSupportsWebHook; }
    public static function getWebhook() as String { return getInstance().webhook; }

    public static function needsBasicAuth() as Boolean { return getInstance().vNeedsBasicAuth; }
    public static function getUser() as String { return getInstance().user; }
    public static function getPassword() as String { return getInstance().password as String; }

    public static function getPollingInterval() as Number { return getInstance().pollingInterval; }

    private function getString( name as String, errorMessage as String ) as String {
        var value = Properties.getValue( name ) as String;
        if( value.equals( "" ) ) {
            throw new ConfigException( errorMessage );
        }
        return value;
    }
}