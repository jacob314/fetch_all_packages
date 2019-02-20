import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum OSInFocusDisplayOption { InAppAlert, Notification, None }

class FlutterOneSignal {
  static MethodChannel _channel = MethodChannel('flutter_one_signal/methods');
  static final EventChannel eventChannel =
      EventChannel('flutter_one_signal/events');

  /// Returns a Future of bool for notification permission granted value
  /// Returns a Future of true instantaneously on Android
  /// And a Future of the result of a notification permission popup on iOS
  static Future<bool> startInit({
    @required String appId,
    OSInFocusDisplayOption inFocusDisplaying =
        OSInFocusDisplayOption.InAppAlert,
    bool unsubscribeWhenNotificationsAreDisabled = false,
    void notificationReceivedHandler(dynamic notification),
    void notificationOpenedHandler(dynamic notification),
  }) async {
    var notificationPermissionGranted =
        await _channel.invokeMethod('startInit', {
      'appId': appId,
      'inFocusDisplaying': inFocusDisplaying.toString(),
      'unsubscribeWhenNotificationsAreDisabled':
          unsubscribeWhenNotificationsAreDisabled.toString()
    });

    eventChannel.receiveBroadcastStream().listen((data) {
      var input = data as String;
      print(input);
      if (input.startsWith('opened:') && notificationOpenedHandler != null) {
        notificationOpenedHandler(input.substring(7, input.length));
      } else if (input.startsWith('received:') &&
          notificationReceivedHandler != null) {
        notificationReceivedHandler(input.substring(9, input.length));
      }
    });

    return notificationPermissionGranted;
  }

  /// Read more here https://documentation.onesignal.com/docs/data-tags
  static sendTag(String key, String value) {
    _channel.invokeMethod('sendTag', {
      'key': key,
      'value': value,
    });
  }

  /// Read more https://documentation.onesignal.com/docs/email-quickstart
  static setEmail(String email) {
    _channel.invokeMethod('setEmail', {
      'email': email,
    });
  }

  /// Read more https://documentation.onesignal.com/docs/email-quickstart
  static logoutEmail() {
    _channel.invokeMethod('logoutEmail');
  }

  /// Read more https://documentation.onesignal.com/docs/player-id
  static Future<String> getUserId() async {
    return await _channel.invokeMethod('getUserId');
  }

  static setSubscription(bool enable) {
    _channel.invokeMethod('setSubscription', {'enable': enable});
  }
}
