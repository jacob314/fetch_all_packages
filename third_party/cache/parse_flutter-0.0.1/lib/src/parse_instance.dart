class ParseInstance {

  String _applicationId;
  String _masterKey;
  String _serverUrl;
  String _liveQueryUrl;
  String _sessionId ;

  String get applicationId => _applicationId;

  set applicationId(String value) {
    _applicationId = value;
  }

  String get masterKey => _masterKey;

  set masterKey(String value) {
    _masterKey = value;
  }

  String get liveQueryUrl => _liveQueryUrl;

  set liveQueryUrl(String value) {
    _liveQueryUrl = value;
  }

  String get serverUrl => _serverUrl;

  set serverUrl(String value) {
    _serverUrl = value;
  }

  String get sessionId => _sessionId;

  set sessionId(String value) {
    _sessionId = value;
  }
}
