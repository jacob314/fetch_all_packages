import 'package:dio/dio.dart';
import 'parse_configuration.dart';
import 'parse_instance.dart';

class ParseHTTPClient {
  ParseInstance parseInstance;
  final Dio _client = Dio();
  final String _userAgent = "Dart Parse SDK 0.1";
  final String _contentType = "application/json";

  ParseHTTPClient(ParseInstance parseInstance) {
    this.parseInstance = parseInstance;
  }

  addUserRequestHeader() {
    _client.options.headers.putIfAbsent("X-Parse-Session-Token", () => "1");
  }

  addSessionHeader(String sessionId) {
    _client.options.headers
        .putIfAbsent("X-Parse-Session-Token", () => sessionId);
  }

  Dio client([Map<String, String> headers]) {
    _client.options.headers.putIfAbsent('user-agent', () => _userAgent);
    _client.options.headers.putIfAbsent('Content-Type', () => _contentType);

    if (headers != null && headers.isNotEmpty) {
      for (var header in headers.entries) {
        _client.options.headers.putIfAbsent(header.key, () => header.value);
      }
    }

    if (ParseConfiguration().getApplicationId() != null)
      _client.options.headers.putIfAbsent('X-Parse-Application-Id',
          () => parseInstance.applicationId);

    if (ParseConfiguration().getMasterKey() != null)
      _client.options.headers.putIfAbsent(
          'X-Parse-Master-Key', () => parseInstance.masterKey);

    return _client;
  }
}
