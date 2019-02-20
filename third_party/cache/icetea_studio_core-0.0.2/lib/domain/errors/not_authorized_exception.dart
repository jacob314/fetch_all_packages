import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class NotAuthorizedException implements Exception {
  final _message;
  final _code = StatusCodes.NOT_AUTHORIZED;

  NotAuthorizedException([this._message]);

  String toString() {
    if (_message == null) return "NotAuthorizedException";
    return "NotAuthorizedException: $_message";
  }
}