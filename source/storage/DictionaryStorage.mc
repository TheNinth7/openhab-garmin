import Toybox.Lang;
import Toybox.Application.Storage;
import Toybox.Application;

typedef StorableDictionary as 
    Dictionary<Application.PropertyKeyType, Application.PropertyValueType>;

(:glance)
class DictionaryStorage {
    
    private static const KEY_SEPARATOR = "*";
    private static const SUB_DICTIONARIES = "**subs**";

    public static function decomposeDictToStorage( 
        key as Application.PropertyKeyType,
        dictionary as StorableDictionary ) as Void {
        decomposeDict( key, dictionary );
        Storage.setValue( key, dictionary );
    }

    public static function reconstructDictFromStorage( 
        key as Application.PropertyKeyType ) as StorableDictionary? {
            return reconstructOrDeleteDictFromStorage(
                key,
                false
            );
    }

    public static function deleteDictFromStorage( 
        key as Application.PropertyKeyType ) as Void {
            reconstructOrDeleteDictFromStorage( key, true );
    }

    private static function decomposeDict( 
        key as Application.PropertyKeyType,
        dictionary as StorableDictionary ) as Void {

        var dictionaryKeys = dictionary.keys();
        var subDictionaries = {};

        for( var i = 0; i < dictionaryKeys.size(); i++ ) {
            var dictionaryKey = dictionaryKeys[i];
            var dvalue = dictionary[dictionaryKey];
            if( dvalue instanceof Dictionary ) {
                var subDictionaryKey = key.toString() + KEY_SEPARATOR + dictionaryKey.toString();
                decomposeDictToStorage( 
                    subDictionaryKey,
                    dvalue
                );
                subDictionaries[dictionaryKey] = subDictionaryKey;
                dictionary.remove( dictionaryKey );
            } else if ( dvalue instanceof Array ) {
                for( var j = 0; j < dvalue.size(); j++ ) {
                    var subArrayElement = dvalue[j];
                    if( subArrayElement instanceof Dictionary ) {
                        decomposeDict( 
                            key.toString() + KEY_SEPARATOR + dictionaryKey.toString() + KEY_SEPARATOR + j,
                            subArrayElement
                        );
                    }
                }
            }
        }
        if( subDictionaries.size() > 0 ) {
            dictionary[SUB_DICTIONARIES] = subDictionaries;
        }
    }

    private static function reconstructOrDeleteDictFromStorage( 
        key as Application.PropertyKeyType,
        delete as Boolean ) as StorableDictionary? {

            var dictionary = Storage.getValue( key );

            if( dictionary instanceof Dictionary ) {
                reconstructOrDeleteDict( key, dictionary, delete );
            } else if( dictionary != null ) {
                dictionary = null;
            }

            // To avoid orphans in case of errors, we delete
            // only if the whole structure nested under this
            // dictionary has been successfully processed
            if( delete ) {
                Storage.deleteValue( key );
            }

            return dictionary as StorableDictionary?;
    }

    private static function reconstructOrDeleteDict( 
        key as Application.PropertyKeyType, 
        dictionary as StorableDictionary,
        delete as Boolean ) as Void {

            var subDictionaries = dictionary[SUB_DICTIONARIES];

            if( subDictionaries instanceof Dictionary ) {
                var subDictionaryKeys = subDictionaries.keys();
                for( var i = 0; i < subDictionaryKeys.size(); i++ ) {
                    var subDictionaryKey = subDictionaryKeys[i];
                    dictionary[subDictionaryKey] =
                        reconstructOrDeleteDictFromStorage( 
                            key.toString() + KEY_SEPARATOR + subDictionaryKey, 
                            delete 
                        );
                }             
            }

            var dictionaryKeys = dictionary.keys();

            for( var i = 0; i < dictionaryKeys.size(); i++ ) {
                var dictionaryKey = dictionaryKeys[i];
                var dvalue = dictionary[dictionaryKey];
                if ( dvalue instanceof Array ) {
                    for( var j = 0; j < dvalue.size(); j++ ) {
                        var subArrayElement = dvalue[j];
                        if( subArrayElement instanceof Dictionary ) {
                            reconstructOrDeleteDict( 
                                key.toString() + KEY_SEPARATOR + dictionaryKey.toString() + KEY_SEPARATOR + j,
                                subArrayElement,
                                delete
                            );
                        }
                    }
                }
            }

            dictionary.remove( SUB_DICTIONARIES );
    }
}