import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;

/*
 * Base class for all sitemap elements, containing members
 * and functions common to both `SitemapWidget` and `SitemapPage`.
 *
 * This class includes only the functionality shared by both,
 * such as the indicator of whether the sitemap is still fresh,
 * and a parser function for widget labels and page titles,
 * which follow the same format.
 */
class SitemapElement {

    // Indicates whether the state is fresh
    // If received via web request, it is always considered
    // fresh, if read from storage it depends on the data's age
    public var isSitemapFresh as Boolean;

    // Constructor
    protected function initialize( initStateFresh as Boolean ) {
        isSitemapFresh = initStateFresh;
    }

    // Widget labels and page titles may include a transformed state in the format:
    //   label [state]
    // The transformed state represents the item's current state with display
    // patterns applied. 
    // This function parses the input into two parts: the label and the state,
    // and returns them as a tuple: [0] = label, [1] = state.
    protected static function parseLabelState( json as JsonAdapter, id as String, errorMessage as String ) as [String, String] {
        var label = json.getString( id, errorMessage );
        var transformedState = null;
        var bracket = label.find( " [" ) as Number?;
        if( bracket != null ) {
            label = label.substring( null, bracket ) as String?;
            if( label == null ) {
                throw new JsonParsingException( "Label '" + label + "' does not have label before the [state]" );
            }
            transformedState = label.substring( bracket+2, null ) as String?;
        }
        if( transformedState == null || transformedState.equals( "-" ) ) {
            transformedState = Item.NO_STATE;
        }
        return [label, transformedState];
    }
}