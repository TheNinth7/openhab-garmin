import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for sitemap menu items. Handles layout responsibilities and
 * supports non-widget menu items not linked to specific sitemap elements.
 * Currently, the only non-widget menu item is for the settings menu item 
 * on touch-based devices.
 *
 * Each menu item comprises:
 *
 * - An optional left-side icon (`ResourceId`)
 *
 * - A center label, passed in as `String`
 *
 * - An optional right-side state, consisting of up to two elements:
 *   - A responsive state text (`String`) that scales automatically with the main label.
 *   - A state indicator (`Drawable`) for displaying bitmaps or fixed-size (non-scaling) text.
 *   - These two elements can be used individually or combined, appearing side by side.
 *
 * - An optional action icon used to indicate that selecting the item will trigger an action.
 *   This icon should be displayed only when the label or state does not clearly convey that
 *   an action is available. For example, toggle-style `Switch` elements do not display an
 *   action icon, whereas `Slider` elements and text-based `Switch` elements do.
 *    
 *   While any `Drawable` can be used as an action icon, this base implementation provides
 *   two standard icons. These are defined as static constants so they can be shared across
 *   all menu items without redundant instantiation.
 *
 * All options can be provided as a dictionary during construction and/or later
 * updated using the corresponding set functions. The layout is performed on the
 * first display and will automatically update only when necessary, based on incoming changes.
 */

class BaseSitemapMenuItem extends BaseMenuItem {

    // The types allowed for the state `Drawable`
    typedef StateDrawable as 
        BufferedBitmapDrawable 
        or Bitmap
        or StateText;

    // The options accepted in the constructor
    typedef Options as {
        :icon as ResourceId?,
        :label as String?,
        :labelColor as ColorType?,
        :stateTextResponsive as String?,
        :stateDrawable as StateDrawable?,
        :stateColor as ColorType?,
        :actionIcon as Bitmap?
    };

    // While any Drawable can be used as an action icon, this base implementation
    // provides two standard icons. These are stored as static constants so that
    // they can be shared across all menu items without redundant instantiation.
    protected static const ACTION_ICON_COMMAND = new Bitmap( { :rezId => Rez.Drawables.chevronRightOrange } );
    protected static const ACTION_ICON_PAGE = new Bitmap( { :rezId => Rez.Drawables.chevronRightOrangeDoubleOrange } );

    // The action icon
    private var _actionIcon as Drawable?;

    // The icon is stored as a tuple containing the resourceId and the Bitmap Drawable.
    // We retain the resourceId so that setIcon can determine whether the new icon
    // is different from the existing one.
    private var _icon as [ResourceId, Bitmap]?;

    // The label is provided as a String, and this class creates a TextArea Drawable for it.
    // Since the constructor uses a function to initialize the label, the type checker
    // cannot guarantee that it is always set. To satisfy the type checker,
    // we initialize the label with an empty string.
    private var _label as String = ""; 
    private var _labelTextArea as TextArea;

    // The set functions set this to true if a change occured
    // that needs the layout to be updated
    private var _layoutUpdateRequested as Boolean = true;

    // See isStateWidthDifferent()
    private var _oldStateWidth as Number? = null;

    // The optional state consists of a responsively sized state (left side)
    // text and/or a Drawable (right side).
    private var _stateDrawable as StateDrawable?;
    
    // The text and its corresponding TextArea are stored as a tuple, similar 
    // to how the icon is handled. The text is retained to allow 
    // setStateTextResponsive() to determine whether it has actually changed.
    private var _stateTextResponsive as [String, TextArea]?;

    // Color of the state    
    private var _stateColor as ColorType = ensureStateColor( null );

    // Constructor
    protected function initialize( options as Options ) {
        BaseMenuItem.initialize();
        _labelTextArea = new TextArea( {
            :font => Constants.UI_MENU_ITEM_FONTS,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :color => ensureLabelColor( null ),
            :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
        } );
        setIcon( options[:icon] as ResourceId? );
        setStateDrawable( options[:stateDrawable] as StateDrawable? );
        var label = options[:label];
        if( label != null ) {
            setLabel( label );            
        }
        setLabelColor( options[:labelColor] );
        setStateTextResponsive( options[:stateTextResponsive] );
        setStateColor( options[:stateColor] );
        setActionIcon( options[:actionIcon] );
    }

    // Assembles the three right-side Drawables into
    // on array, for easier processing in onLayout()
    private function collectRightSideDrawables() as Array<Drawable> {
        var rightSideDrawables = new Array<Drawable>[0];
        if( _actionIcon != null ) { 
            rightSideDrawables.add( _actionIcon ); 
        }
        if( _stateDrawable != null ) { 
            rightSideDrawables.add( _stateDrawable ); 
        }
        if( _stateTextResponsive != null ) { 
            rightSideDrawables.add( _stateTextResponsive[1] ); 
        }
        return rightSideDrawables;
    }

    // Takes the optional label color as argument and
    // if it is null returns the default color
    private function ensureLabelColor( labelColor as ColorType? ) as ColorType {
        return labelColor != null ? labelColor : Constants.UI_COLOR_TEXT;
    }

    // Takes the optional state color as argument and
    // if it is null returns the default color
    private function ensureStateColor( stateColor as ColorType? ) as ColorType {
        return stateColor != null ? stateColor : Constants.UI_COLOR_INACTIVE;
    }

    // Returns the label of the menu item as String
    public function getLabel() as String {
        return _label;
    }

    // The state Drawable can change without a set function being called,
    // so we track its width to detect changes that may require a layout update.
    // This function returns true if the current Drawable's width differs
    // from the previously stored width.
    private function isStateWidthDifferent() as Boolean {
        return ! LittleHelpers.nullSafeEquals(
            _oldStateWidth,
            LittleHelpers.getDrawableWidthOrNull( _stateDrawable )
        );
    }

    /*
    * onLayout() is called when the menu item is first displayed,
    * and subsequently by onUpdate() if any element changes in a way 
    * that requires the layout to be recalculated.
    *
    * The layout is determined by the sizes of the individual elements,
    * along with spacing constants that define the gaps between them.
    *
    * For more details, see `DefaultConstants`, where these constants are defined
    * and their relationships are visually explained.
    */
    private function onLayout( dc as Dc ) as Void {
        Logger.debug( "onLayout" );
        var dcWidth = dc.getWidth();
        var dcHeight = dc.getHeight();
        
        // Calculate spacing and left padding
        var spacing = ( dcWidth * Constants.UI_MENU_ITEM_SPACING_FACTOR ).toNumber();
        var stateSpacing = ( dcWidth * Constants.UI_MENU_ITEM_STATE_SPACING_FACTOR ).toNumber();

        // Throughout this function, leftX is the current position
        // of elements that are aligned to the left (icon and label)
        // Initially, the left padding is applied
        var leftX = ( dcWidth * Constants.UI_MENU_ITEM_PADDING_LEFT_FACTOR ).toNumber();
        
        // If there is an icon, we initialize it and
        // then set leftX to the position next to it
        // Also the title width is adjusted
        if( _icon != null ) {
            var iconBitmap = _icon[1];
            iconBitmap.setLocation( 
                leftX, 
                ( ( (dc.getHeight()/2) - iconBitmap.height/2 ) * 1.1 ).toNumber() 
            );
            leftX += Constants.UI_MENU_ITEM_ICON_WIDTH + spacing;
        }

        // Throughout this function, rightX is the current position
        // of elements that are aligned to the right (state and action icon)
        // Initially, the right padding is applied
        var rightX = 
            dcWidth
                - ( dcWidth * Constants.UI_MENU_ITEM_PADDING_RIGHT_FACTOR ).toNumber();

        var rightSideDrawables = collectRightSideDrawables();

        for( var i = 0; i < rightSideDrawables.size(); i++ ) {
            var rightSideDrawable = rightSideDrawables[i];

            if( i == rightSideDrawables.size() - 1 
                && rightSideDrawable instanceof TextArea 
                && _stateTextResponsive != null
            ) {
                rightSideDrawable.setSize( 
                    ( ( rightX - leftX - spacing )
                        * TextDimensions.getWidthRatio( 
                            _stateTextResponsive[0], 
                            _label ) ).toNumber(),
                    dcHeight * 0.8 
                );
            }

            rightX -= LittleHelpers.getDrawableWidth( rightSideDrawable );

            rightSideDrawable.setLocation( rightX, WatchUi.LAYOUT_VALIGN_CENTER );

            if( i < rightSideDrawables.size() - 1 ) {
                rightX -= stateSpacing;
            } else {
                rightX -= spacing;
            }
        }

        // Finally the text area is initialized
        // At the calculated leftX and width
        _labelTextArea.locX = leftX;
        _labelTextArea.setSize( rightX - leftX, dcHeight );
    }

    // Optional override to handle item selection (e.g., enter button or touch tap).
    // @return true if the event was handled, false otherwise.
    // In class hierarchies, a subclass can call the parent's onSelect and proceed
    // with its own logic only if the parent did not handle the event.
    public function onSelect() as Boolean { return false; }

    // Called by the base class to render the menu item.
    public function onUpdate( dc as Dc ) as Void {
        if( _layoutUpdateRequested == true || isStateWidthDifferent() ) {
            onLayout( dc );
            _layoutUpdateRequested = false;
            updateOldStateWidth();
        }
    
        LittleHelpers.drawTupleIfNotNull( _icon, dc );
        _labelTextArea.draw( dc );
        LittleHelpers.drawTupleIfNotNull( _stateTextResponsive, dc );
        LittleHelpers.drawIfNotNull( _stateDrawable, dc );
        LittleHelpers.drawIfNotNull( _actionIcon, dc );
    }

    // Called by the set functions to signal that the layout 
    // needs to be recalculated during the next onUpdate() call.
    // Layout requires a valid Dc, so it can only be performed within onUpdate().
    private function requestLayoutUpdate() as Void {
        _layoutUpdateRequested = true;
    }


    // Sets the optional action icon.
    // The icon is updated—and a layout update is requested—only if it has actually changed.
    protected function setActionIcon( actionIcon as Bitmap? ) as Void {
        if( ! LittleHelpers.nullSafeEquals( _actionIcon, actionIcon ) ) {
            _actionIcon = actionIcon;
            requestLayoutUpdate();
        }
    }

    // Sets or updates the icon.
    // Although this class doesn't require it directly, the API's CustomMenu
    // class (which this is based on) inherits setIcon from MenuItem.
    // Therefore, we must follow that function signature, even though
    // we only support ResourceId as input.
    protected function setIcon( 
        iconResourceId as 
            Graphics.BitmapType 
            or Drawable 
            or ResourceId 
            or Null
    ) as Void {
        if( iconResourceId != null ) {
            // We only accept ResourceId
            if( ! ( iconResourceId instanceof ResourceId ) ) {
                throw new GeneralException( "Only ResourceId supported" );
            }
            if( _icon == null ) {
                // If there was no icon before, create the tuple
                _icon = [
                    iconResourceId,
                    new Bitmap( { :rezId => iconResourceId } )
                ];
                requestLayoutUpdate();
            } else if( ! iconResourceId.equals( _icon[0] ) ) {
                // Otherwise update it, but only when the ResourceId
                // has changed
                _icon[0] = iconResourceId;
                _icon[1].setBitmap( iconResourceId );
                requestLayoutUpdate();
            }
        } else if( _icon != null ) {
            // If the icon was set to null, remove it
            _icon = null;
            requestLayoutUpdate();
        }
    }

    // Overrides MenuItem.setLabel to handle string labels only.
    //
    // Although CustomMenuItem does not require a label, it inherits the setLabel()
    // method from its base class MenuItem. We override it here to enforce the use
    // of string labels and to guard against premature calls before the label
    // text area is initialized.
    protected function setLabel( label as String or ResourceId ) as Void {
        if( ! _label.equals( label ) ) {
            // Due to inheritance, we must accept ResourceId arguments, even though
            // our app only supports string labels. Therefore, we reject ResourceId 
            // inputs explicitly.
            if( label instanceof ResourceId ) {
                throw new GeneralException( "Only string labels are supported" );
            }

            // MenuItem may call setLabel("") during its own initialization.
            // At that point, _labelTextArea may not yet be initialized.
            // We handle this case gracefully by checking for null.
            if( _labelTextArea != null ) {
                _label = label;
                _labelTextArea.setText( label );
            } else {
                // If the label is not an empty string, this likely indicates a logic error.
                // Throw an exception to signal improper usage.            
                if( ! label.equals( "" ) ) {
                    throw new GeneralException( "setLabel called before initialization" );
                }
                // If it is an empty string, we silently ignore it.
            }

            requestLayoutUpdate();
        }        
    }

    // Sets or updates the label color
    protected function setLabelColor( labelColor as ColorType? ) as Void {
        _labelTextArea.setColor( ensureLabelColor( labelColor ) );
    }

    // Sets or replaces the state Drawable
    protected function setStateDrawable( stateDrawable as StateDrawable? ) as Void {
        _stateDrawable = stateDrawable;
    }

    // Sets the optional state color.
    // The color is applied to both the responsive state text and the state Drawable,
    // if the Drawable is of the StateText type.
    // Coloring Bitmap Drawables is not currently supported, but may be added in the future.
    protected function setStateColor( stateColor as ColorType? ) as Void {
        _stateColor = ensureStateColor( stateColor );
        if( _stateDrawable instanceof StateText ) {
            ( _stateDrawable as StateText ).setColor( _stateColor );
        }
        if( _stateTextResponsive != null ) {
            _stateTextResponsive[1].setColor( _stateColor );
        }
    }

    // Set or update the responsive state text
    protected function setStateTextResponsive( text as String? ) as Void {
        if( text != null ) {
            if( _stateTextResponsive == null ) {
                // If the next was newly added, we create the tuple ...
                _stateTextResponsive = [
                    text,
                    new TextArea( {
                        :text => text,
                        :font => Constants.UI_MENU_ITEM_FONTS,
                        :locY => WatchUi.LAYOUT_VALIGN_CENTER,
                        :justification => Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER,
                        :color => _stateColor,
                        :backgroundColor => Constants.UI_MENU_ITEM_BG_COLOR,
                    } )
                ];
                requestLayoutUpdate();
            } else {
                // ... otherwise we update it, but only if the text changed
                var stateTextResponsive = _stateTextResponsive;
                if( ! stateTextResponsive[0].equals( text ) ) {
                    stateTextResponsive[0] = text;
                    stateTextResponsive[1].setText( text );
                    requestLayoutUpdate();
                }
            }
        } else if( _stateTextResponsive != null ) {
            // If the text was set to null, we remove it
            _stateTextResponsive = null;
            requestLayoutUpdate();
        }
    }

    // Updates the stored state width
    // See isStateWidthDifferent()
    private function updateOldStateWidth() as Void {
        _oldStateWidth = LittleHelpers.getDrawableWidthOrNull( _stateDrawable ); 
    }
}