import Toybox.Lang;

typedef JsonObject as Dictionary<String,Object?>;
typedef JsonArray as Array<JsonObject>;

typedef OHMenuItem as interface {
    function update( sitemapElement as SitemapElement ) as Boolean;
    function isMyType( sitemapElement as SitemapElement ) as Boolean;
};
