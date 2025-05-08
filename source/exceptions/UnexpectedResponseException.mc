import Toybox.Lang;

/*
    Used when a web request returned response code 200 (success)
    but the response data was not of the expected type
    One notable thing: there seem to be some differences between
    how certain Garmin devices (or mobile phones) deal with an unexpected
    response. Some return response code -400, others return 200 but
    an empty (null) response.
*/
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