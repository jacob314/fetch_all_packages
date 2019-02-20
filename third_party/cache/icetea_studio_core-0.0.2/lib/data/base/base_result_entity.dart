import 'package:icetea_studio_core/domain/constants/global.dart' show StatusCodes;

class BaseResultEntity {
  int _status;
  dynamic _data;
  int _total;
  String _message;

  BaseResultEntity(this._status, this._data);

  BaseResultEntity.fromJson(Map<String, dynamic> map) :
    _status = map['statusCode'],
    _message = map['message'],
    _data = map['contractData'],
    _total = map.containsKey('total') ? map['total'] : 0;

  int get status => _status;

  String get message => _message;

  dynamic get data => _data;

  int get total => _total;

  bool get isSuccess => _status == StatusCodes.SUCCESS;
}
