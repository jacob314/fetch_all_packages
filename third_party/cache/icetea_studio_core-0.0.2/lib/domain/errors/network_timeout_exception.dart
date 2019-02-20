class NetworkTimeoutException implements Exception {
  final _message;
  String _url;

  NetworkTimeoutException([this._message, this._url]);

  String toString() {
    if (_message == null) return "NetworkTimeoutException";
    return "NetworkTimeoutException: $_message - from Url: $_url";
  }
}
