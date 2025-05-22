import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application;
import Toybox.Time;
import Toybox.System;

/*
 * `SitemapStore` manages access to sitemap-related data stored in persistent Storage.
 * This includes the timestamp of when the current sitemap was obtained and the sitemap label.
 * While the timestamp and label are cached in memory, the full JSON representation of the sitemap
 * is discarded immediately after being written to Storage in order to minimize memory usage.
 *
 * The caching strategy prioritizes memory efficiency. Although writing the sitemap JSON to Storage 
 * is relatively slow, keeping it in memory would be significantly more demanding. In particular, 
 * if we only discarded the JSON after receiving a new one via a web request, we’d temporarily 
 * have two full copies in memory, which is problematic on memory-constrained devices.
 *
 * To avoid this, the sitemap JSON is written to Storage and immediately discarded from memory
 * as soon as it is received. The only exception is the first fresh sitemap after the app starts: 
 * it is not stored. This avoids a performance hit during initial startup when the UI cannot yet 
 * show states. Storage begins only from the second fresh sitemap onward.
 *
 * This approach has an additional benefit: the two most memory-intensive operations—making a web 
 * request and writing to Storage—occur consecutively. Web requests fail gracefully with an 
 * out-of-memory (OOM) error, allowing us to inform the user and suggest reducing sitemap size. 
 * In contrast, writing to Storage can crash the app on OOM. To mitigate this, we estimate 
 * memory requirements based on usage during the web request and only proceed with writing 
 * to Storage if sufficient memory is available.
 *
 * The sitemap JSON is stored as a tuple containing the raw JSON and a timestamp marking its age.
 * This timestamp is compared against a configurable expiry time to determine freshness.
 * The result is propagated to the `SitemapHomepage` and related classes, and also used for 
 * error handling via the `isSitemapFresh()` method.
 *
 * On older devices with limited memory, the glance view may be unable to load the full JSON or 
 * perform web requests. To support such cases, the sitemap label is stored separately, allowing 
 * at least the label to be displayed in the glance view.
 */

(:glance)
class SitemapStore  {
    
    // Names of the sitemap JSON and label in storage
    private static const STORAGE_JSON as String = "sitemapJson";
    private static const STORAGE_LABEL as String = "sitemapLabel";

    // The JSON is stored with this type, to keep it together
    // with the timestamp of when it was otbained
    typedef StoredJson as [JsonObject, Number];

    // Timer after which a sitemap is considered stale, in seconds
    private static const STATE_EXPIRATION_TIME as Number = 10;

    // In memory we only keep the timestamp and the label
    // The sitemap is persisted and then discarded to preserve memory
    private static var _sitemapTimestamp as Number?;
    private static var _sitemapLabel as String?;

    // Sitemap access is handled via three functions:
    // - createSitemapFromStorage: Loads the sitemap from persistent storage.
    // - createAndStoreSitemapFromJson: Creates a sitemap from a JSON object and stores it.
    // - deleteSitemapFromStorage: Removes the currently stored sitemap from storage.

    // When loading the sitemap from storage, only the timestamp is retained in memory.
    // The JSON is used to construct the SitemapHomepage and then immediately discarded
    // to minimize memory usage.
    public static function createSitemapFromStorage() as SitemapHomepage? {
        var storedJson = Storage.getValue( STORAGE_JSON ) as StoredJson?;
        if( storedJson != null ) {
            _sitemapTimestamp = storedJson[1];
            Logger.debug( "SitemapStore.createSitemapFromStorage: stored JSON found, fresh=" + isSitemapFresh() );
            return new SitemapHomepage( storedJson[0], isSitemapFresh() );
        }
        Logger.debug( "SitemapStore.createSitemapFromStorage: no stored JSON was found" );
        return null;
    }
    
    // Creates a SitemapHomepage from a fresh JSON received from the server
    // and writes it to Storage.
    //
    // Writing to Storage is a memory-intensive operation and poses a risk of 
    // fatal out-of-memory (OOM) errors. To mitigate this, we estimate the 
    // memory usage of the JsonObject and approximate the memory required 
    // for writing. We proceed only if there is sufficient available memory.
    //
    // NOTE: Writing to Storage is also time-consuming. To avoid delaying the
    // initial UI update with fresh state data, we skip writing the first fresh 
    // sitemap after app startup.
    private static var _alreadyHasFreshSitemap as Boolean = false;
    public static function createAndStoreSitemapFromJson( json as JsonObject, estimatedSitemapSize as Number ) as SitemapHomepage {
        Logger.debug( "SitemapStore.createAndStoreSitemapFromJson" );
        var homepage = new SitemapHomepage( json, true );
        _sitemapTimestamp = Time.now().value();
        _sitemapLabel = homepage.label;

        if( _alreadyHasFreshSitemap || OHApp.isGlance() ) {
            Logger.debug( "SitemapStore: already had fresh sitemap, writing to storage" );
            Storage.setValue( STORAGE_LABEL, _sitemapLabel );

            Logger.debug( "SitemapStore: used memory = " + System.getSystemStats().usedMemory + " B" );
            Logger.debug( "SitemapStore: total memory = " + System.getSystemStats().totalMemory + " B" );
            Logger.debug( "SitemapStore: free memory = " + System.getSystemStats().freeMemory + " B" );
            Logger.debug( "SitemapStore: est. sitemap size = " + estimatedSitemapSize + " B" );

            // Only write to memory if the JSON takes less than 80kB in memory
            // Testing has shown that somewher around 90kB, Storage.setValue
            // will crash, independent of free memory
            if( estimatedSitemapSize <= 81920 ) {
                Logger.debug( "SitemapStore: sufficient free memory, writing to storage" );
                Storage.setValue( 
                    STORAGE_JSON, 
                    [json, _sitemapTimestamp] as Array<PropertyValueType>
                );
            } else {
                Logger.debug( "SitemapStore: insufficient free memory, skipping and clearing storage" );
                deleteSitemapFromStorage();
            }
        } else {
            Logger.debug( "SitemapStore: first fresh sitemap, skipping storage" );
            _alreadyHasFreshSitemap = true;
        }

        return homepage;
    }

    // Deletes the sitemap from Storage to invalidate it in case of a fatal
    // error during a sitemap request. After such an error, the sitemap should
    // only be shown again once fresh data has been successfully retrieved.
    public static function deleteSitemapFromStorage() as Void {
        Logger.debug( "SitemapStore.deleteSitemapFromStorage" );
        Storage.deleteValue( STORAGE_JSON );
        _sitemapTimestamp = null;
    }

    // Checks whether the currently stored timestamp is still within 
    // the configured expiry duration, indicating that the sitemap is fresh.
    public static function isSitemapFresh() as Boolean {
        if( _sitemapTimestamp != null ) {
            var dataAge = 
                Time.now().compare( 
                    new Moment( _sitemapTimestamp as Number ) 
                );
            // Logger.debug( "SitemapStore.isSitemapFresh=" + ( dataAge < STATE_EXPIRATION_TIME ) );
            return dataAge < STATE_EXPIRATION_TIME;
        } else {
            return false;
        }
    }

    // Return the current label
    public static function getLabel() as String? {
        if( _sitemapLabel == null ) {
            _sitemapLabel = Storage.getValue( STORAGE_LABEL ) as String?;
        }
        return _sitemapLabel;
    }
}