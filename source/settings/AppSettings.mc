import Toybox.Lang;
import Toybox.Application.Properties;

/*
* Singleton class providing static access to application settings.
*/
class AppSettings {

    // Singleton accessor
    // is private and only used by the static accessors for each setting
    private static var _instance as AppSettings?;
    private static function get() as AppSettings {
        if( _instance == null ) {
            _instance = new AppSettings();
        }
        return _instance as AppSettings;
    }

    // Static accessors for all values
    public static function getUrl() as String { return get().url; }
    public static function getSitemap() as String { return get().sitemap; }
    public static function supportsRestApi() as Boolean { return get().vSupportsRESTAPI; }
    public static function suppressEmptyResponseExceptions() as Boolean { return get().vSuppressEmtpyResponses; }
    public static function supportsWebhook() as Boolean { return get().vSupportsWebHook; }
    public static function getWebhook() as String { return get().webhook; }
    public static function needsBasicAuth() as Boolean { return get().vNeedsBasicAuth; }
    public static function getUser() as String { return get().user; }
    public static function getPassword() as String { return get().password as String; }
    public static function getPollingInterval() as Number { return get().pollingInterval; }

    // Prefix of the server-specific settings
    // Currently only index=0 is supported (e.g. url_0),
    // but in future there will be support for multiple servers
    private var _index as Number = 0;
    private const URL_PREFIX = "url_";
    private const SITEMAP_PREFIX = "sitemap_";
    private const USER_PREFIX = "user_";
    private const PASSWORD_PREFIX = "password_";
    private const RESTAPI_PREFIX = "restapi_";
    private const SUPPRESS_EMRES_PREFIX = "suppressEmptyResponseExceptions_";
    private const WEBHOOK_PREFIX = "webhook_";
    private const INTERVAL_PREFIX = "pollingInterval_";

    // The constructor stores all settings in the following
    // variables. They need to be public, because otherwise
    // the static accessors cannot access them
    public var url as String;
    public var sitemap as String;
    public var vSupportsRESTAPI as Boolean = false;
    public var vSuppressEmtpyResponses as Boolean = false;
    public var vSupportsWebHook as Boolean = false;
    public var webhook as String = "";
    public var vNeedsBasicAuth as Boolean = false;
    public var user as String;
    public var password as String?;
    public var pollingInterval as Number;

    /* Constants to be set for sideloading a build
       (sideloaded builds do not support settings configuration via UI)
    public var url as String = "http://net-nas-1:8080/";
    public var sitemap as String = "garmin_stress";
    public var vSupportsRESTAPI as Boolean = true;
    public var pollingInterval as Number = 0;
    public var user as String = "";
    */

    /*
    * Constructor.
    * Loads all application settings at initialization.
    * To support multiple servers in the future, this should be refactored
    * to load settings dynamically when a new server is selected.
    */
    private function initialize() {
        // Read the server URL
        url = getString( URL_PREFIX + _index, "Configuration: URL is missing" );
        // Other code assumes the server URL ends with a slash (e.g., https://home.myopenhab.org/).
        // If it’s missing, append one here.
        var lastChar = url.substring( url.length()-1, url.length() );
        if( lastChar != null && ! lastChar.equals( "/" ) ) {
            url += "/";
        }

        // Sitemap name
        sitemap = getString( SITEMAP_PREFIX + _index, "Configuration: sitemap is missing" );
        
        // Check if native REST APIs are activated in the settings ...
        vSupportsRESTAPI = Properties.getValue( RESTAPI_PREFIX + _index ) as Boolean;
        if( ! vSupportsRESTAPI ) {
            // ... and if not, check if a Webhook has been configured.
            webhook = Properties.getValue( WEBHOOK_PREFIX + _index ) as String;
            vSupportsWebHook = ! webhook.equals( "" );
        }

        // Should we suppress empty responses?
        vSuppressEmtpyResponses = Properties.getValue( SUPPRESS_EMRES_PREFIX + _index ) as Boolean;

        // User and password for basic authentication
        user = Properties.getValue( USER_PREFIX + _index ) as String;
        if( ! user.equals( "" ) ) {
            vNeedsBasicAuth = true;
            password = getString( PASSWORD_PREFIX + _index, "Configuration: password is missing" );
        }
        
        // The polling interval defines how often sitemap data is polled
        pollingInterval = Properties.getValue( INTERVAL_PREFIX + _index ) as Number;
    }

    // Helper function that reads a string setting and throws an error if it
    // is not set
    private function getString( name as String, errorMessage as String ) as String {
        var value = Properties.getValue( name ) as String;
        if( value.equals( "" ) ) {
            throw new ConfigException( errorMessage );
        }
        return value;
    }
}