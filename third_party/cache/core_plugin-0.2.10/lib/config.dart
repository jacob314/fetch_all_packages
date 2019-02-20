import 'package:flutter/services.dart';

class Config {
  static String domain = "";
  static const platformChannel = const MethodChannel('com.sendo.flutter.io/channel/main');

  static const eventChannel = EventChannel('com.sendo.flutter.io/event');

}
