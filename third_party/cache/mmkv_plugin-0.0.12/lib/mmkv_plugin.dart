import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class Mmkv {
  static const MethodChannel _channel = const MethodChannel('mmkv');

  Mmkv._(this.isDefault, this.id);

  final bool isDefault;
  final String id;

  static Future<Mmkv> defaultInstance() {
    Completer<Mmkv> completer = Completer();
    _channel
        .invokeMethod('default')
        .then((value) => completer.complete(Mmkv._(true, null)))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  static Future<Mmkv> withId(String id) {
    Completer<Mmkv> completer = Completer();
    _channel
        .invokeMethod('withId', {'id': id})
        .then((value) => completer.complete(Mmkv._(false, id)))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  static Future<Mmkv> withCryptKey(String id, Uint8List cryptKey) {
    Completer<Mmkv> completer = Completer();
    _channel
        .invokeMethod('withCryptKey', {'id': id, 'cryptKey': cryptKey})
        .then((value) => completer.complete(Mmkv._(false, id)))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<T> _invoke<T>(String method, Map<String, dynamic> arguments) {
    Map<String, dynamic> params = {};
    if (this.isDefault) {
      params['default'] = true;
    } else {
      params['id'] = this.id;
    }
    params.addAll(arguments);
    Completer<T> completer = Completer();
    _channel
        .invokeMethod(method, params)
        .then((value) => completer.complete(value as T))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<void> put(String key, dynamic value) async {
    switch (value.runtimeType) {
      case bool:
        return await this.putBoolean(key, value);
      case int:
        return await this.putInt(key, value);
      case String:
        return await this.putString(key, value);
      case Uint8List:
        return await this.putBytes(key, value);
      case double:
        return await this.putDouble(key, value);
      default:
        return Future.error('invalid type');
    }
  }

  Future<void> putBoolean(String key, bool value) async =>
      await _invoke('putBoolean', {'key': key, 'value': value});

  Future<void> putInt(String key, int value) async =>
      await _invoke('putLong', {'key': key, 'value': value});

  Future<void> putString(String key, String value) async =>
      await _invoke('putString', {'key': key, 'value': value});

  Future<void> putBytes(String key, Uint8List value) async =>
      await _invoke('putBytes', {'key': key, 'value': value});

  Future<void> putDouble(String key, double value) async =>
      await _invoke('putDouble', {'key': key, 'value': value});

  Future<bool> getBoolean(String key) => _invoke('getBoolean', {'key': key});

  Future<int> getInt(String key) => _invoke<int>('getLong', {'key': key});

  Future<String> getString(String key) => _invoke('getString', {'key': key});

  Future<Uint8List> getBytes(String key) => _invoke('getBytes', {'key': key});

  Future<double> getDouble(String key) => _invoke('getDouble', {'key': key});

  Future<bool> containsKey(String key) => _invoke('containsKey', {'key': key});

  Future<void> remove(String key) => _invoke('remove', {'key': key});

  Future<void> clear() => _invoke('clear', {});

  Future<List<String>> keys() {
    Completer<List<String>> completer = Completer();
    _invoke<List<dynamic>>('keys', {})
        .then((keys) => completer.complete(keys.whereType<String>().toList()))
        .catchError((error) => completer.completeError(error));
    return completer.future;
  }

  Future<int> count() => _invoke('count', {});

  Future<void> removeValuesForKeys(List<String> keys) =>
      _invoke('removeValuesForKeys', {'keys': keys});
}
