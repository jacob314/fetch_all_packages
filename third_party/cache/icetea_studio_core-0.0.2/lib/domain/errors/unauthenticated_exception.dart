import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class UnAuthenticatedException implements Exception {
  final _message;
  final _code = StatusCodes.AUTH_ERROR;

  UnAuthenticatedException([this._message]);

  String toString() {
    if (_message == null) return "UnAuthenticatedException";
    return "UnAuthenticatedException: $_message";
  }
}