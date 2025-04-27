import Toybox.Lang;
import Toybox.Communications;

typedef JsonObject as Dictionary<String,Object?>;
typedef JsonArray as Array<JsonObject>;

typedef OHMenuItem as interface {
    function update( sitemapElement as SitemapElement ) as Boolean;
    function isMyType( sitemapElement as SitemapElement ) as Boolean;
};

typedef OHCommandMenuItem as interface {
    function getItemName() as String;
    function onCommandComplete() as Void;
};

typedef WebRequestOptions as { :method as Communications.HttpRequestMethod, :headers as Lang.Dictionary, :responseType as Communications.HttpResponseContentType, :context as Lang.Object or Null, :maxBandwidth as Lang.Number };