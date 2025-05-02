import Toybox.Lang;

(:glance)
class UnexpectedResponseException extends CommunicationBaseException {

    private var _data as Object?;

    public function initialize( data as Object?, source as CommunicationBaseException.Source ) {
        CommunicationBaseException.initialize( source );
        _data = data;
    }

    public function getErrorMessage() as String or Null {
        return getSourceName() + ": " + (
            _data == null ?
            "Empty response" :
            "Unexpected response (" + _data + ")"
            );
    }

    public function getToastMessage() as String {
        return getSourceShortCode() + ":" + ( _data == null ? "EMRES" : "UNRES" );
    }
}