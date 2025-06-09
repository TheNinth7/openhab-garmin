import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for all widget elements. Contains members and functions
 * common to all widgets, including:
 * - the label
 * - The display state: the item's state with display patterns applied.
 *   - `remoteDisplayState` holds the display state as provided by the server.
 *   - `displayState` may override `remoteDisplayState` with additional local display logic.
 * - the display colors
 * - any page linked to this widget
 */
class SitemapWidget extends SitemapElement {

    // Initializes displayState with remoteDisplayState; 
    // subclasses may override it with custom display logic.
    public var displayState as String;
    
    // The iconType transformed into a bitmap resource id
    public var icon as ResourceId?;
    
    // The icon type as specified in the sitemap
    public var iconType as String;
    
    // The item associated with this widget
    public var item as Item?;
    
    // The label, without any embedded display state
    // See remoteDisplayState and SitemapElement.parseLabel()
    public var label as String;

    // The color to be applied to the label
    public var labelColor as ColorType?;
    
    // For Group elements and nested elements
    public var linkedPage as SitemapContainer?;
    
    // The display state provided by the server.
    // Extracted from the item label in the format: "Label [displayState]"
    // See SitemapElement.parseLabel()
    public var remoteDisplayState as String;
    
    // The widget type
    public var type as String;

    // The value color is applied to the displayed state
    public var valueColor as ColorType?;

    // Constructor
    protected function initialize( 
        json as JsonAdapter, 
        initSitemapFresh as Boolean,
        asyncProcessing as Boolean
    ) {
        SitemapElement.initialize( initSitemapFresh );

        type = json.getString( "type", "Widget without type" );

        var fullLabel = parseLabelState( json, "label", "Widget label is missing" );
        label = fullLabel[0];
        remoteDisplayState = fullLabel[1];
        
        // displayState is initialized with the one from the server
        // but may be updated with local logic by subclasses
        displayState = remoteDisplayState;

        // If staticIcon is true, we do not use the
        // item state when selecting an icon but
        // use the default presentation of the
        // dynamic icons 
        iconType = json.getOptionalString( "icon" );
        icon = parseIcon( 
            iconType, 
            json.getBoolean( "staticIcon" )
                ? null
                : item           
        );

        if( ! iconType.equals( "" ) ) {
        } else {
            iconType = json.getOptionalString( "staticIcon" );
            icon = parseIcon( iconType, null );
        }

        labelColor = parseColor( json, "labelcolor", "Widget '" + label + "': invalid label color" );
        valueColor = parseColor( json, "valuecolor", "Widget '" + label + "': invalid value color" );

        var jsonLinkedPage = json.getOptionalObject( "linkedPage" );
        if( jsonLinkedPage != null ) {
            linkedPage = new SitemapPage( jsonLinkedPage, initSitemapFresh, asyncProcessing );
        }
    }

    // Determines if a display state is available
    public function hasDisplayState() as Boolean {
        return ! displayState.equals( Item.NO_STATE );
    }

    // Parses a color field.
    // The field may be missing or empty, in which case null is returned.
    // Otherwise, it can contain either a color name (e.g., "red") or a hex code 
    // (e.g., "#FF0000"). In both cases, a ColorType is returned—specifically, 
    // a number between 0x000000 and 0xFFFFFF.
    private function parseColor( json as JsonAdapter, id as String, errorMessage as String ) as ColorType? {
        var colorString = json.getOptionalString( id );
        if( colorString == null || colorString.equals( "" ) ) {
            return null;
        }
        switch ( colorString ) {
            case "maroon": return 0x800000;
            case "red": return 0xff0000;
            case "orange": return 0xffa500;
            case "olive": return 0x808000;
            case "yellow": return 0xffff00;
            case "purple": return 0x800080;
            case "fuchsia": return 0xff00ff;
            case "pink": return 0xffc0cb;
            case "white": return 0xffffff;
            case "lime": return 0x00ff00;
            case "green": return 0x008000;
            case "navy": return 0x000080;
            case "blue": return 0x0000ff;
            case "teal": return 0x008080;
            case "aqua": return 0x00ffff;
            case "black": return 0x000000;
            case "silver": return 0xc0c0c0;
            case "gray": return 0x808080;
            case "gold": return 0xffd700;
        }
        var leadChar = colorString.substring( null, 1);
        if( leadChar != null && leadChar.equals( "#" ) ) {
            colorString = colorString.substring( 1, null );
            if( colorString != null ) {
                var colorNumber = ( colorString ).toNumberWithBase( 0x10 );
                if( colorNumber != null ) {
                    if( colorNumber >= 0 && colorNumber <= 16777215 ) {
                        return colorNumber;
                    }
                }
            }
        }
        throw new JsonParsingException( errorMessage );
    }

    // Get the ResourceId for the icon
    // Icon is optional, so this function may return null
    // If available we also apply the item state
    protected static function parseIcon( iconType as String, item as Item? ) as ResourceId? {
        if( ! iconType.equals( "" ) ) {
            var itemState = Item.NO_STATE;
            if( item != null ) {
                itemState = item.state;
            }
            switch( iconType ) {
                case "slider":
                case "light": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        if( itemState.equals( SwitchItem.ITEM_STATE_OFF ) ) {
                            return Rez.Drawables.menuLight00;
                        } else {
                            return Rez.Drawables.menuLight10;
                        }
                    } else {
                        if( numericItemState >= 100 ) {
                            return Rez.Drawables.menuLight10;
                        } else if( numericItemState >= 90 ) {
                            return Rez.Drawables.menuLight09;
                        } else if( numericItemState >= 80 ) {
                            return Rez.Drawables.menuLight08;
                        } else if( numericItemState >= 70 ) {
                            return Rez.Drawables.menuLight07;
                        } else if( numericItemState >= 60 ) {
                            return Rez.Drawables.menuLight06;
                        } else if( numericItemState >= 50 ) {
                            return Rez.Drawables.menuLight05;
                        } else if( numericItemState >= 40 ) {
                            return Rez.Drawables.menuLight04;
                        } else if( numericItemState >= 30 ) {
                            return Rez.Drawables.menuLight03;
                        } else if( numericItemState >= 20 ) {
                            return Rez.Drawables.menuLight02;
                        } else if( numericItemState >= 10 ) {
                            return Rez.Drawables.menuLight01;
                        } else {
                            return Rez.Drawables.menuLight00;
                        }
                    }
                }

                case "lightbulb": return Rez.Drawables.menuLight10;

                case "garagedoor": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        if( itemState.equals( SwitchItem.ITEM_STATE_CLOSED ) ) {
                            return Rez.Drawables.menuGaragedoor10;
                        } else if( itemState.equals( SwitchItem.ITEM_STATE_OPEN ) ) {
                            return Rez.Drawables.menuGaragedoor00;
                        } else {
                            return Rez.Drawables.menuGaragedoor05;
                        }
                    } else {
                        if( numericItemState >= 100 ) {
                            return Rez.Drawables.menuGaragedoor10;
                        } else if( numericItemState >= 90 ) {
                            return Rez.Drawables.menuGaragedoor09;
                        } else if( numericItemState >= 80 ) {
                            return Rez.Drawables.menuGaragedoor08;
                        } else if( numericItemState >= 70 ) {
                            return Rez.Drawables.menuGaragedoor07;
                        } else if( numericItemState >= 60 ) {
                            return Rez.Drawables.menuGaragedoor06;
                        } else if( numericItemState >= 50 ) {
                            return Rez.Drawables.menuGaragedoor05;
                        } else if( numericItemState >= 40 ) {
                            return Rez.Drawables.menuGaragedoor04;
                        } else if( numericItemState >= 30 ) {
                            return Rez.Drawables.menuGaragedoor03;
                        } else if( numericItemState >= 20 ) {
                            return Rez.Drawables.menuGaragedoor02;
                        } else if( numericItemState >= 10 ) {
                            return Rez.Drawables.menuGaragedoor01;
                        } else {
                            return Rez.Drawables.menuGaragedoor00;
                        }
                    }
                }

                case "blinds":
                case "rollershutter": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null || numericItemState >= 100 ) {
                        return Rez.Drawables.menuRollershutter10;
                    } else if( numericItemState >= 90 ) {
                        return Rez.Drawables.menuRollershutter09;
                    } else if( numericItemState >= 80 ) {
                        return Rez.Drawables.menuRollershutter08;
                    } else if( numericItemState >= 70 ) {
                        return Rez.Drawables.menuRollershutter07;
                    } else if( numericItemState >= 60 ) {
                        return Rez.Drawables.menuRollershutter06;
                    } else if( numericItemState >= 50 ) {
                        return Rez.Drawables.menuRollershutter05;
                    } else if( numericItemState >= 40 ) {
                        return Rez.Drawables.menuRollershutter04;
                    } else if( numericItemState >= 30 ) {
                        return Rez.Drawables.menuRollershutter03;
                    } else if( numericItemState >= 20 ) {
                        return Rez.Drawables.menuRollershutter02;
                    } else if( numericItemState >= 10 ) {
                        return Rez.Drawables.menuRollershutter01;
                    } else {
                        return Rez.Drawables.menuRollershutter00;
                    }
                }
 
                case "screen": {
                    if( itemState.equals( SwitchItem.ITEM_STATE_OFF ) ) {
                        return Rez.Drawables.menuScreenOff;
                    } else {
                        return Rez.Drawables.menuScreenOn;
                    }
                }

                case "temperature": {
                    return Rez.Drawables.menuTemperature;
                }

                case "humidity": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        return Rez.Drawables.menuHumidity05;
                    } else {
                        if( numericItemState >= 100 ) {
                            return Rez.Drawables.menuHumidity10;
                        } else if( numericItemState >= 90 ) {
                            return Rez.Drawables.menuHumidity09;
                        } else if( numericItemState >= 80 ) {
                            return Rez.Drawables.menuHumidity08;
                        } else if( numericItemState >= 70 ) {
                            return Rez.Drawables.menuHumidity07;
                        } else if( numericItemState >= 60 ) {
                            return Rez.Drawables.menuHumidity06;
                        } else if( numericItemState >= 50 ) {
                            return Rez.Drawables.menuHumidity05;
                        } else if( numericItemState >= 40 ) {
                            return Rez.Drawables.menuHumidity04;
                        } else if( numericItemState >= 30 ) {
                            return Rez.Drawables.menuHumidity03;
                        } else if( numericItemState >= 20 ) {
                            return Rez.Drawables.menuHumidity02;
                        } else if( numericItemState >= 10 ) {
                            return Rez.Drawables.menuHumidity01;
                        } else {
                            return Rez.Drawables.menuHumidity00;
                        }
                    }
                }

                case "batterylevel": {
                    var numericItemState = itemState.toNumber();
                    
                    if( numericItemState == null ) {
                        return Rez.Drawables.menuBatteryLevel07;
                    } else {
                        if( numericItemState >= 100 ) {
                            return Rez.Drawables.menuBatteryLevel10;
                        } else if( numericItemState >= 90 ) {
                            return Rez.Drawables.menuBatteryLevel09;
                        } else if( numericItemState >= 80 ) {
                            return Rez.Drawables.menuBatteryLevel08;
                        } else if( numericItemState >= 70 ) {
                            return Rez.Drawables.menuBatteryLevel07;
                        } else if( numericItemState >= 60 ) {
                            return Rez.Drawables.menuBatteryLevel06;
                        } else if( numericItemState >= 50 ) {
                            return Rez.Drawables.menuBatteryLevel05;
                        } else if( numericItemState >= 40 ) {
                            return Rez.Drawables.menuBatteryLevel04;
                        } else if( numericItemState >= 30 ) {
                            return Rez.Drawables.menuBatteryLevel03;
                        } else if( numericItemState >= 20 ) {
                            return Rez.Drawables.menuBatteryLevel02;
                        } else if( numericItemState >= 10 ) {
                            return Rez.Drawables.menuBatteryLevel01;
                        } else {
                            return Rez.Drawables.menuBatteryLevel00;
                        }
                    }
                }

                case "lowbattery": return Rez.Drawables.menuBatteryLevel00;

                case "radiator": return Rez.Drawables.menuRadiator;

            }
        }
        return null;
    }
}