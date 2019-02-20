import 'dart:async';

import 'package:flutter/services.dart';

class Lchelloworld {
  static const MethodChannel _channel =
      const MethodChannel('lchelloworld');

  static Future<String> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');
}
