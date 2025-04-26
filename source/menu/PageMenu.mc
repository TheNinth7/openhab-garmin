import Toybox.Lang;
import Toybox.WatchUi;

class PageMenu extends Menu2 {
    function initialize( sitemapPage as SitemapPage ) {
        Menu2.initialize( {
            :title => sitemapPage.label,
        } );

        var elements = sitemapPage.elements;
        for( var i = 0; i < elements.size(); i++ ) {
            var element = elements[i];
            if( element instanceof SitemapSwitch ) {
                addItem( new SwitchMenuItem( element ) );
            } else {
                throw new JsonParsingException( "Page '" + sitemapPage.label + "' contains item not supported by menu." );
            }
        }
    }

    function update( sitemapPage as SitemapPage ) as Void {
    }
}