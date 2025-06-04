import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Abstract base class for menu items that display sitemap widgets.
 *
 * This class maps widget-specific properties from the given `SitemapWidget` to the menu item
 * and shares some configuration with its superclass, `BaseSitemapMenuItem`.
 *
 * In addition to this property mapping, it implements support for nested sitemap elements,
 * such as frames or groups, by enabling submenu navigation.
 *
 * To support submenu functionality, subclasses should override `onSelect()` and call this
 * base class implementation. If `onSelect()` returns `true`, the event was handled by this
 * class (e.g., opening a submenu). If it returns `false`, the subclass can proceed with
 * its own handling of the select event.
 */

// Defines the options accepted by the `BaseSitemapWidgetItem` class.
typedef BaseWidgetMenuItemOptions as {
    :sitemapWidget as SitemapWidget,
    :state as Drawable?,
    :isActionable as Boolean?, // if true, the action icon is displayed
    :parent as BasePageMenu
};

class BaseWidgetMenuItem extends BaseSitemapMenuItem {

    // The submenu representing the nested elements, if there are any
    private var _page as PageMenu?;
    
    // Reference to the parent menu is required so that submenus
    // can navigate back. Submenus may be created not only in the
    // constructor, but also dynamically in updateWidget(), so we
    // store the parent menu as a member variable.
    private var _parent as BasePageMenu;

    // Constructor
    protected function initialize( 
        options as BaseWidgetMenuItemOptions
    ) {
        // Store the parent
        _parent = options[:parent] as BasePageMenu;

        // Extract the widget
        var sitemapWidget = options[:sitemapWidget] as SitemapWidget;

        // And initialize the base class, partly with data from
        // the SitemapWidget, partly with other options
        BaseSitemapMenuItem.initialize( {
            :label => sitemapWidget.label,
            :labelColor => sitemapWidget.labelColor,
            :state => options[:state],
            :stateColor => sitemapWidget.valueColor,
            :isActionable => options[:isActionable]
        } );

        // If the widget has a linked page, we initialize a sub menu for it
        if( sitemapWidget.linkedPage != null ) {
            _page = new PageMenu( 
                sitemapWidget.linkedPage as SitemapContainerImplementation, 
                _parent 
            );
        }
    }

    // Returns true if the widget is linked to a page (sub menu)
    public function hasPage() as Boolean {
        return _page != null;
    }
    
    // Subclasses must override this method to determine whether the given
    // `SitemapWidget` instance is compatible with this menu item type.
    public static function isMyType( sitemapWidget as SitemapWidget ) as Boolean { 
        throw new AbstractMethodException( "BaseSitemapMenuItem.getItemType" );
    }

    // Handles selection of the menu item.
    // If a submenu is present, it is opened on selection. This typically takes precedence
    // over changing the state of the item. Therefore, subclasses should first call the
    // parent class’s onSelect() method. If it returns false (i.e., the event was not handled),
    // the subclass can proceed with its own selection logic (e.g., state changes).
    //
    // Subclasses without custom selection behavior, such as FrameMenuItem or TextMenuItem,
    // do not need to override this method.
    public function onSelect() as Boolean { 
        if( _page != null ) {
            ViewHandler.pushView( _page, PageMenuDelegate.get(), WatchUi.SLIDE_LEFT );
            return true;
        } else {
            return false;
        }
    }

    /*
     * Updates the menu item with new data received from the server.
     * The provided `SitemapWidget` contains the updated information.
     *
     * Subclasses may override this method if they need to process additional
     * parts of the update, but they must also call the base class’s
     * updateWidget() to ensure core functionality is preserved.
     */
    public function updateWidget( sitemapWidget as SitemapWidget ) as Void { 
        updateOptions( {
            :label => sitemapWidget.label,
            :labelColor => sitemapWidget.labelColor,
            :stateColor => sitemapWidget.valueColor,
        } );

        var linkedPage = sitemapWidget.linkedPage as SitemapContainerImplementation;

        if( linkedPage != null && _page != null ) {
            _page.update( linkedPage );
        } else if( linkedPage != null && _page == null ) {
            _page = new PageMenu( linkedPage, _parent );
        } else {
            _page = null;
        }
    }
}