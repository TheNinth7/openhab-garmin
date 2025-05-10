import Toybox.Lang;

// Types representing dictionary and array objects used for JSON structures 
// sent to or received from web requests.
typedef JsonObject as Dictionary<String,Object?>;
typedef JsonArray as Array<JsonObject>;