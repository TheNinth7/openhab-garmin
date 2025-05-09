import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

/*
 * Base class for page menus.
 *
 * Page menus act as containers for primitive sitemap elements. 
 * These containers correspond to elements like the Homepage and Frames, 
 * while primitive elements include items such as Switches and Text elements.
 *
 * This class handles both the creation of menu items based on the sitemap 
 * and the logic for updating the menu in response to changes in the sitemap.
 */
class BasePageMenu extends BaseMenu {
    
    // The label for the menu
    private var _label as String;

    // Constructor
    protected function initialize( sitemapPage as SitemapPage, footer as Drawable? ) {
        _label = sitemapPage.label;
        
        // Initialize the super class
        BaseMenu.initialize( {
                :title => _label,
                :itemHeight => Constants.UI_MENU_ITEM_HEIGHT,
                :footer => footer
            } );

        // For each element in the page, create a menu item
        var elements = sitemapPage.elements;
        for( var i = 0; i < elements.size(); i++ ) {
            addItem( createMenuItem( elements[i] ) );
        }
    }

    /*
    * Updates the menu based on a new sitemap state.
    *
    * Returns `true` if the overall menu structure remains unchanged (i.e., no pages or frames 
    * were added or removed). If the structure has changed, the function returns `false`, and 
    * the view will reset to the `HomepageMenu` after the update.
    *
    * Sitemap-assigned identifiers are effectively positional indexes. When a new element is 
    * inserted in the middle of a page, it receives the identifier previously assigned to the 
    * item at that position, and subsequent items are reindexed accordingly.
    *
    * The update algorithm compares each new sitemap element with the existing menu item at 
    * the corresponding position:
    *   - If the types match, the item is updated in place.
    *   - If the types differ, the existing item is replaced.
    *   - If no matching menu item exists for a given index, a new one is added.
    *   - If any existing menu items remain after processing all sitemap elements, they are removed.
    *
    * This allows for efficient repurposing of menu items when changes are made mid-list, provided 
    * the types are compatible. For example, inserting a `Switch` in the middle of a list of `Switch` 
    * items will cause the menu item at that position to be reused for the new `Switch`, and subsequent 
    * items will be repurposed or extended as needed.
    */
    public function update( sitemapPage as SitemapPage ) as Boolean {
        _label = sitemapPage.label;
        
        // Update the title of the menu
        setTitleAsString( _label );

        var structureRemainsValid = true;

        // Loop through all elements in the new sitemap state
        var elements = sitemapPage.elements;
        var i = 0;
        for( ; i < elements.size(); i++ ) {
            var element = elements[i];
            var itemIndex = findItemById( element.id );
            if( itemIndex == -1 ) {
                // If the item does not exist yet, we create it
                addItem( createMenuItem( element ) );
                Logger.debug( "PageMenu.update: adding new item to page '" + _label + "'" );
            } else {
                // If the item is found, we check if the type of the menu
                // item is the same or has changed
                var item = getItem( itemIndex ) as BaseSitemapMenuItem;
                if( item.isMyType( element ) ) {
                    // If the type is the same, we update the menu item
                    if( item.update( element ) == false ) {
                        structureRemainsValid = false;
                        Logger.debug( "PageMenu.update: page '" + _label + "' invalid because item '" + item.getLabel() + "' invalid" );
                    }
                } else {
                    // If the type is not the same, we create a new item
                    // and replace the existing menu item with it
                    var newItem = createMenuItem( element );
                    if( item instanceof PageMenuItem || newItem instanceof PageMenuItem ) {
                        structureRemainsValid = false;
                        Logger.debug( "PageMenu.update: page '" + _label + "' invalid because item '" + item.getLabel() + "' changed type from/to page" );

                    }
                    updateItem( newItem, itemIndex );
                }
            }
        }
        // Remove all menu items that do not have a corresponding
        // sitemap element anymore
        while( getItem( i ) != null ) {
            if( getItem( i ) instanceof PageMenuItem ) {
                structureRemainsValid = false;
            }
            deleteItem( i );
            Logger.debug( "PageMenu.update: page '" + _label + "' invalid because item was removed" );
        }
        return structureRemainsValid;
    }

    // Creates a menu item based on the sitemap element type
    private function createMenuItem( sitemapElement as SitemapElement ) as CustomMenuItem {
        if( OnOffMenuItem.isMyType( sitemapElement ) ) {
            return new OnOffMenuItem( sitemapElement as SitemapSwitch );
        } else if( TextMenuItem.isMyType( sitemapElement ) ) {
            return new TextMenuItem( sitemapElement as SitemapText );
        } else if( sitemapElement instanceof SitemapPage ) {
            return new PageMenuItem( sitemapElement, self );
        } else {
            throw new JsonParsingException( "Element '" + sitemapElement.label + "' on page '" + _label + "' is not supported" );
        }
    }
}