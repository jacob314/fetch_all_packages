import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class MissingTokenException implements Exception {
  final _message;
  final _code = StatusCodes.MISSING_AUTH_TOKEN;

  MissingTokenException([this._message]);

  String toString() {
    if (_message == null) return "MissingTokenException";
    return "MissingTokenException: $_message";
  }
}