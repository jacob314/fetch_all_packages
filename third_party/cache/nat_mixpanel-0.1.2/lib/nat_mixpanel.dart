import 'package:flutter/services.dart';

class NatMixpanel {
  static final NatMixpanel _mixpanel = new NatMixpanel._internal();

  factory NatMixpanel() => _mixpanel;

  NatMixpanel._internal();

  void init(String token) async {
    await _channel.invokeMethod("init", {"token": token});
  }

  static const MethodChannel _channel = const MethodChannel('mixpanel');

  void track(String eventName, {Map properties, Function callback}) async {
    if (properties != null)
      _channel.invokeMethod(
          "track", {"event": eventName, "properties": properties});
    else
      _channel.invokeMethod("track", {"event": eventName});
  }
}
