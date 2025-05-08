import Toybox.Lang;

/*
    Monkey C does not support abstract methods. So in base
    classes, we do an implementation of methods that shall
    be implemented by derived classes, and have them throw an
    AbstractMethodException, to ensure that the derived class
    overrides it.
*/
(:glance)
class AbstractMethodException extends GeneralException {
    function initialize( msg as String ) {
        GeneralException.initialize( msg );
    }
}
