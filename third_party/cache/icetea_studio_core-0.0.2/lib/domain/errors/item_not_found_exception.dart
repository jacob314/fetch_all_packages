import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class ItemNotFoundException implements Exception {
  final _message;
  final _code = StatusCodes.ITEM_NOT_FOUND;

  ItemNotFoundException([this._message]);

  String toString() {
    if (_message == null) return "ItemNotFoundException";
    return "ItemNotFoundException: $_message";
  }
}