import Toybox.Lang;

class TouchArea {
    private var _id as Symbol;

    protected function initialize( id as Symbol ) {
        _id = id;
    }

    public function getId() as Symbol {
        return _id;
    }

    public function contains( coordinates as [Number, Number] ) as Boolean {
        throw new AbstractMethodException( "TouchArea.contains" );        
    }
}