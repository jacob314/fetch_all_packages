import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class MessageUserUnavailbaleException implements Exception {
  final _message;
  final _code = StatusCodes.USER_UNAVAILABLE;

  MessageUserUnavailbaleException([this._message]);

  String toString() {
    if (_message == null) return "MessageUserUnavailbaleException";
    return "MessageUserUnavailbaleException: $_message";
  }
}