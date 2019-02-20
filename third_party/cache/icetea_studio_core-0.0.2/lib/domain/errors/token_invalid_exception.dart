import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class TokenInvalidException implements Exception {
  final _message;
  final _code = StatusCodes.ITEM_NOT_FOUND;

  TokenInvalidException([this._message]);

  String toString() {
    if (_message == null) return "TokenInvalidException";
    return "TokenInvalidException: $_message";
  }
}