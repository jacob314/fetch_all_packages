import 'dart:async';

import 'package:flutter/services.dart';

class Applications {
  static const MethodChannel _channel =
      const MethodChannel('applicationsMethodChannel');

  static Future<String> get getApplications async {
    final String version = await _channel.invokeMethod('getApplications');
    return version;
  }
}
