import Toybox.Lang;
import Toybox.WatchUi;

class PageMenu extends Menu2 {
    function initialize( sitemapPage as SitemapPage ) {
        Menu2.initialize( {
            :title => sitemapPage.label,
            :footer => new Bitmap( {
                :rezId => Rez.Drawables.OpenHabText,
                :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_CENTER } )
        } );

        var elements = sitemapPage.elements;
        for( var i = 0; i < elements.size(); i++ ) {
            addItem( createMenuItem( elements[i], sitemapPage.label ) );
        }
    }

    function update( sitemapPage as SitemapPage ) as Boolean {
        var remainsValid = true;

        setTitle( sitemapPage.label );

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

    private function createMenuItem( sitemapElement as SitemapElement, pageTitle as String ) as MenuItem {
        if( sitemapElement instanceof SitemapSwitch ) {
            return new SwitchMenuItem( sitemapElement );
        } else if( sitemapElement instanceof SitemapPage ) {
            return new PageMenuItem( sitemapElement );
        } else {
            throw new JsonParsingException( "Page '" + pageTitle + "' contains item not supported by menu." );
        }
    }
}