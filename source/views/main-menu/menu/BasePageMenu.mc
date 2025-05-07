import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

class BasePageMenu extends BaseMenu {
    private var _label as String;

    public static var ITEM_HEIGHT as Number = 
        ( System.getDeviceSettings().screenHeight * 0.2 ).toNumber();

    protected function initialize( sitemapPage as SitemapPage, footer as Drawable? ) {
        _label = sitemapPage.label;
        
        BaseMenu.initialize( {
                :title => _label,
                :itemHeight => ITEM_HEIGHT,
                :footer => footer
            } );

        var elements = sitemapPage.elements;
        for( var i = 0; i < elements.size(); i++ ) {
            addItem( createMenuItem( elements[i] ) );
        }
    }

    public function update( sitemapPage as SitemapPage ) as Boolean {
        _label = sitemapPage.label;
        setTitleAsString( _label );

        var remainsValid = true;

        var elements = sitemapPage.elements;
        var i = 0;
        for( ; i < elements.size(); i++ ) {
            var element = elements[i];
            var itemIndex = findItemById( element.id );
            if( itemIndex == -1 ) {
                addItem( createMenuItem( element ) );
                Logger.debug( "PageMenu.update: adding new item to page '" + _label + "'" );
            } else {
                var item = getItem( itemIndex ) as BaseSitemapMenuItem;
                if( item.isMyType( element ) ) {
                    if( item.update( element ) == false ) {
                        remainsValid = false;
                        Logger.debug( "PageMenu.update: page '" + _label + "' invalid because item '" + item.getLabel() + "' invalid" );
                    }
                } else {
                    var newItem = createMenuItem( element );
                    if( item instanceof PageMenuItem || newItem instanceof PageMenuItem ) {
                        remainsValid = false;
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
                remainsValid = false;
            }
            deleteItem( i );
            Logger.debug( "PageMenu.update: page '" + _label + "' invalid because item was removed" );
        }
        return remainsValid;
    }

    private function createMenuItem( sitemapElement as SitemapElement ) as CustomMenuItem {
        if( OnOffMenuItem.isMyType( sitemapElement ) ) {
            return new OnOffMenuItem( sitemapElement as SitemapSwitch );
        } else if( TextMenuItem.isMyType( sitemapElement ) ) {
            return new TextMenuItem( sitemapElement as SitemapText );
        } else if( sitemapElement instanceof SitemapPage ) {
            return new PageMenuItem( sitemapElement );
        } else {
            throw new JsonParsingException( "Element '" + sitemapElement.label + "' on page '" + _label + "' is not supported" );
        }
    }
}