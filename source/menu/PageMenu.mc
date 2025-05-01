import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class PageMenu extends CustomMenu {
    private var _title as Text;
    private var _label as String;

    public static var ITEM_HEIGHT as Number = 
        ( System.getDeviceSettings().screenHeight * 0.2 ).toNumber();
    //public static const FOOTER_HEIGHT as Number = ( ITEM_HEIGHT * 1.85 ).toNumber();

    function initialize( sitemapPage as SitemapPage ) {
        _label = sitemapPage.label;
        _title = new Text( {
            :text => _label,
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_SMALL,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        } );

        // The following options should alter the height of title and footer
        // footer works, title does not, so omitting this for now. Probably
        // a bug in the SDK.
        // :labelItemHeight => itemHeight,
        // :footerItemHeight => itemHeight

        CustomMenu.initialize( 
            ITEM_HEIGHT,
            Graphics.COLOR_BLACK, 
            {
                :title => _title,
                :footer => new Bitmap( {
                    :rezId => Rez.Drawables.logoOpenhabText,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } )
                //:footerItemHeight => ( FOOTER_HEIGHT ).toNumber()
            } );

        var elements = sitemapPage.elements;
        for( var i = 0; i < elements.size(); i++ ) {
            addItem( createMenuItem( elements[i], sitemapPage.label ) );
        }
    }

    function update( sitemapPage as SitemapPage ) as Boolean {
        var remainsValid = true;

        _title.setText( sitemapPage.label );

        var elements = sitemapPage.elements;
        var i = 0;
        for( ; i < elements.size(); i++ ) {
            var element = elements[i];
            var itemIndex = findItemById( element.id );
            if( itemIndex == -1 ) {
                addItem( createMenuItem( element, sitemapPage.label ) );
                Logger.debug( "PageMenu.update: adding new item to page '" + _label + "'" );
            } else {
                var item = getItem( itemIndex ) as BaseMenuItem;
                if( item.isMyType( element ) ) {
                    if( item.update( element ) == false ) {
                        remainsValid = false;
                        Logger.debug( "PageMenu.update: page '" + _label + "' invalid because item '" + item.getLabel() + "' invalid" );
                    }
                } else {
                    var newItem = createMenuItem( element, sitemapPage.label );
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

    private function createMenuItem( sitemapElement as SitemapElement, pageTitle as String ) as CustomMenuItem {
        if( OnOffMenuItem.isMyType( sitemapElement ) ) {
            return new OnOffMenuItem( sitemapElement as SitemapSwitch );
        } else if( TextMenuItem.isMyType( sitemapElement ) ) {
            return new TextMenuItem( sitemapElement as SitemapText );
        } else if( sitemapElement instanceof SitemapPage ) {
            return new PageMenuItem( sitemapElement );
        } else {
            throw new JsonParsingException( "Page '" + pageTitle + "' contains item not supported by menu." );
        }
    }
}