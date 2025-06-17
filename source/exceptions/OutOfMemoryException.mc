import Toybox.Lang;

/*
 * Exception thrown if there is not enough memory for an operation.
 */
 (:glance)
class OutOfMemoryException extends GeneralException {
    function initialize() {
        GeneralException.initialize( "Out of Memory. Please restart the app. If the issue continues, try reducing the sitemap size." );
    }
}
