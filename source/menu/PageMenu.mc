import Toybox.Lang;
import Toybox.WatchUi;

class PageMenu extends CustomMenu {
    function initialize( sitemapPage as SitemapPage ) {
        CustomMenu.initialize( 80, Graphics.COLOR_BLACK, {} )

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
        if( OnOffMenuItem.isMyType( sitemapElement ) ) {
            return new TestCustomMenuItem();
            //return new OnOffMenuItem( sitemapElement as SitemapSwitch );
        } else if( sitemapElement instanceof SitemapPage ) {
            return new PageMenuItem( sitemapElement );
        } else {
            throw new JsonParsingException( "Page '" + pageTitle + "' contains item not supported by menu." );
        }
    }
}