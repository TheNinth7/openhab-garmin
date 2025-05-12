import Toybox.Lang;
import Toybox.WatchUi;

/*
 * Class representing `Switch` elements.
 * Currently, it relies entirely on the functionality provided 
 * by its superclass and does not add any additional behavior.
 */
class SitemapSwitch extends SitemapPrimitiveElement {
    private const ITEM_GROUP_TYPE = "groupType";
    
    private const ITEM_TYPE_GROUP = "Group";

    public function initialize( data as JsonObject ) {
        SitemapPrimitiveElement.initialize( data );
        if( itemType.equals( ITEM_TYPE_GROUP ) ) {
            itemType =  getString( getItem( data ), ITEM_GROUP_TYPE, "Element '" + label + "': group has no type" );
        }
    }
}