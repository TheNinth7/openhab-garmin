import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for all widget elements. Contains members and functions
 * common to all widgets, including:
 * - the label
 * - The display state: the item's state with display patterns applied.
 *   - `_remoteDisplayState` holds the display state as provided by the server.
 *   - `_displayState` may override `_remoteDisplayState` with additional local display logic.
 * - the display colors
 * - any page linked to this widget
 */
class SitemapWidget extends SitemapElement {

    // See the get accessors for documentation
    private var _displayState as String;
    private var _icon as ResourceId?;
    private var _iconType as String;
    private var _item as Item?;
    private var _label as String;
    private var _labelColor as ColorType?;
    private var _linkedPage as SitemapContainer?;
    private var _remoteDisplayState as String;
    private var _type as String;
    private var _valueColor as ColorType?;

    // Constructor
    // @param json - The JSON object representing this widget.
    // @param item - The associated item. Not all subclasses require one,
    //               and the item type may vary by widget. The subclass
    //               creates and passes in the item so it can be accessed
    //               through the generic SitemapWidget interface.
    // @param linkedPage - By default, this class parses the `linkedPage`
    //                     from the JSON. For special cases like Frame elements,
    //                     the `linkedPage` is passed explicitly to override
    //                     the default behavior.
    // @param isSitemapFresh - Indicates whether the sitemap is fresh
    //                         (i.e., within its expiry period and containing up-to-date state).
    // @param asyncProcessing - Whether asynchronous processing should be applied.
    protected function initialize( 
        json as JsonAdapter, 
        item as Item?,
        linkedPage as SitemapContainer?,
        isSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapElement.initialize( isSitemapFresh );

        _item = item;

        _type = json.getString( "type", "Widget without type" );

        var fullLabel = parseLabelState( json, "label", "Widget label is missing" );
        _label = fullLabel[0];
        _remoteDisplayState = fullLabel[1];
        
        // _displayState is initialized with the one from the server
        // but may be updated with local logic by subclasses
        _displayState = _remoteDisplayState != null
                            ? _remoteDisplayState
                            : _item != null
                                ? _item.getState()
                                : NO_DISPLAY_STATE;

        // If staticIcon is true, we do not use the
        // item state when selecting an icon but
        // use the default presentation of the
        // dynamic icons 
        _iconType = json.getOptionalString( "icon" );
        _icon = IconParser.parse( 
            _iconType, 
            json.getBoolean( "staticIcon" )
                ? null
                : _item           
        );

        if( ! _iconType.equals( "" ) ) {
        } else {
            _iconType = json.getOptionalString( "staticIcon" );
            _icon = IconParser.parse( _iconType, null );
        }

        _labelColor = ColorParser.parse( json, "labelcolor", "Widget '" + _label + "': invalid label color" );
        _valueColor = ColorParser.parse( json, "valuecolor", "Widget '" + _label + "': invalid value color" );

        if( linkedPage != null ) {
            _linkedPage = linkedPage;
        } else {
            var jsonLinkedPage = json.getOptionalObject( "linkedPage" );
            if( jsonLinkedPage != null ) {
                _linkedPage = new SitemapPage( jsonLinkedPage, isSitemapFresh, asyncProcessing );
            }
        }
    }

    // The display state is initialized with the remote display state; 
    // subclasses may override it with custom display logic.
    public function getDisplayState() as String { return _displayState; }

    // As default the display state is set to NO_DISPLAY_STATE if it
    // is not available. This function can be used if absence of a
    // display state should be expressed as null.
    public function getDisplayStateOrNull() as String? { 
        if( _displayState.equals( NO_DISPLAY_STATE ) ) {
            return null;
        } else {
            return _displayState; 
        }
    }

    // The _iconType transformed into a bitmap resource id
    public function getIcon() as ResourceId? { return _icon; }
    
    // The icon type as specified in the sitemap
    public function getIconType() as String { return _iconType; }
    
    // The item associated with this widget
    public function getItem() as Item? { return _item; }
    
    // The label, without any embedded display state
    // See _remoteDisplayState and SitemapElement.parseLabel()
    public function getLabel() as String { return _label; }

    // The color to be applied to the label
    public function getLabelColor() as ColorType? { return _labelColor; }
    
    // For Group elements and nested elements
    public function getLinkedPage() as SitemapContainer? { return _linkedPage; }
    
    // The display state provided by the server.
    // Extracted from the item label in the format: "Label [_displayState]"
    // See SitemapElement.parseLabel()
    public function getRemoteDisplayState() as String { return _remoteDisplayState; }

    // The widget type
    public function getType() as String { return _type; }

    // The value color is applied to the displayed state
    public function getValueColor() as ColorType? { return _valueColor; }

    // Determines if a display state is available
    public function hasRemoteDisplayState() as Boolean {
        return ! _displayState.equals( NO_DISPLAY_STATE );
    }

    // Determines if a display state is available
    public function hasDisplayState() as Boolean {
        return ! _displayState.equals( NO_DISPLAY_STATE );
    }

    // To be used to update the state if a change
    // is triggered from within the app
    public function processUpdatedState() as Void {
        _icon = IconParser.parse( _iconType, _item );
        _remoteDisplayState = NO_DISPLAY_STATE;
        _displayState = _item != null
                            ? _item.getState()
                            : NO_DISPLAY_STATE;
    }
}