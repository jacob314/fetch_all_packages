import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class UnknownErrorException implements Exception {
  final _message;
  final _code = StatusCodes.UNKNOWN_ERROR;

  UnknownErrorException([this._message]);

  String toString() {
    if (_message == null) return "UnknowErrorException";
    return "UnknowErrorException: $_message";
  }
}