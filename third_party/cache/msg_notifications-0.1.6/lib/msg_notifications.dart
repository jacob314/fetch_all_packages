import 'dart:async';

import 'package:flutter/services.dart';

class NotificationEvent {
  String _packageName;
  String _title;
  String _ticker;
  String _message;
  DateTime _timeStamp;

  NotificationEvent(this._packageName) {
    _timeStamp = DateTime.now();
    List<String> temp = this._packageName.split(":;:");
    this._packageName = temp[0];
    this._title = temp[1];
    this._ticker = temp[2];
    this._message = temp[3];
  }

  String get packageName => _packageName;
  String get title => _title;
  String get ticker => _ticker;
  String get message => _message;
  DateTime get timeStamp => _timeStamp;

  @override
  String toString() {
    return "[$packageName sent notification @ $timeStamp:$title:$ticker:$message";
  }
}

NotificationEvent _notificationEvent(String event) {
  return new NotificationEvent(event);
}

class MsgNotifications {
  static const EventChannel _notificationEventChannel =
  EventChannel('notifications.eventChannel');

  Stream<NotificationEvent> _notificationStream;

  Stream<NotificationEvent> get stream {
    if (_notificationStream == null) {
      _notificationStream = _notificationEventChannel
          .receiveBroadcastStream()
          .map((event) => _notificationEvent(event));
    }
    return _notificationStream;
  }
}
