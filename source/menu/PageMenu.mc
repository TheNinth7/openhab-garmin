import Toybox.Lang;
import Toybox.WatchUi;

class PageMenu extends CustomMenu {
    private var _title as Text;

    private const ITEM_HEIGHT_PERCENTAGE = 0.2;

    function initialize( sitemapPage as SitemapPage ) {
        _title = new Text( {
            :text => sitemapPage.label,
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_SMALL,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        } );

        var itemHeight = ( System.getDeviceSettings().screenHeight * ITEM_HEIGHT_PERCENTAGE ).toNumber();

        // The following options should alter the height of title and footer
        // footer works, title does not, so omitting this for now. Probably
        // a bug in the SDK.
        // :labelItemHeight => itemHeight,
        // :footerItemHeight => itemHeight

        CustomMenu.initialize( 
            itemHeight,
            Graphics.COLOR_BLACK, 
            {
                :title => _title,
                :footer => new Bitmap( {
                    :rezId => Rez.Drawables.OpenHabText,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_CENTER } ),
                :footerItemHeight => ( itemHeight * 1.85 ).toNumber()
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
            } else {
                var item = getItem( itemIndex ) as OHMenuItem;
                if( item.isMyType( element ) ) {
                    if( item.update( element ) == false ) {
                        remainsValid = false;
                    }
                } else {
                    updateItem( createMenuItem( element, sitemapPage.label ), itemIndex );
                    remainsValid = false;
                }
            }
        }
        // Remove all menu items that do not have a corresponding
        // sitemap element anymore
        for( ; getItem( i ) != null; i++ ) {
            deleteItem( i );
            remainsValid = false;
        }
        return remainsValid;
    }

    private function createMenuItem( sitemapElement as SitemapElement, pageTitle as String ) as CustomMenuItem {
        if( OnOffMenuItem.isMyType( sitemapElement ) ) {
            return new OnOffMenuItem( sitemapElement as SitemapSwitch );
        } else if( sitemapElement instanceof SitemapPage ) {
            return new PageMenuItem( sitemapElement );
        } else {
            throw new JsonParsingException( "Page '" + pageTitle + "' contains item not supported by menu." );
        }
    }
}