class FetchDataException implements Exception {
  final _message;
  String _url;

  FetchDataException([this._message, this._url]);

  String toString() {
    if (_message == null) return "FetchdataException";
    return "FetchdataException: $_message - from Url: $_url";
  }
}
