import 'dart:async';

import 'package:flutter/services.dart';

final MethodChannel _channel = const MethodChannel('com.jarvanmo/tobias');

Future<Map> pay(String order) async {
  return await _channel.invokeMethod("pay", order);
}

Future<String> version() async {
  return await _channel.invokeMethod("version");
}
