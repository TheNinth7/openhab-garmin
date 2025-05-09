import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Base class for all primitive sitemap elements—those that do not 
 * contain other elements.
 *
 * Examples of primitive elements: `Switch`, `Text`
 * Examples of container elements: `Homepage`, `Frame`
 */
class SitemapPrimitiveElement extends SitemapElement {

    // JSON field names
    private const ITEM = "item";
    private const ITEM_NAME = "name";
    private const ITEM_TYPE = "type";
    private const ITEM_STATE = "state";

    // Fields read from the JSON
    public var itemName as String;
    public var itemState as String;
    public var itemType as String;
    
    // Constructor
    protected function initialize( data as JsonObject ) {
        // First initialize the super class
        // We need the label from the super class for the error messages below
        SitemapElement.initialize( data );
        // ... and then read all the elements
        var item = getObject( data, ITEM, "Element '" + label + "': no item found" );
        itemName = getString( item, ITEM_NAME, "Element '" + label + "': item has no name" );
        itemType = getString( item, ITEM_TYPE, "Element '" + label + "': item has no type" );
        itemState = getString( item, ITEM_STATE, "Element '" + label + "': item has no state" );
    }
}