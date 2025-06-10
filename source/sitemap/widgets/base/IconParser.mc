import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/**
 * Parses icon names from a JSON dictionary into a ResourceId.
 */
class IconParser {

    // Get the ResourceId for the icon
    // Icon is optional, so this function may return null
    // If available we also apply the item state
    public static function parse( iconType as String, item as Item? ) as ResourceId? {
        if( ! iconType.equals( "" ) ) {
            var itemState = "";
            if( item != null ) {
                itemState = item.getState();
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