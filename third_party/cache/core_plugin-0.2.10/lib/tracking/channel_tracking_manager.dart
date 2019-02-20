import 'dart:async';
import 'package:core_plugin/config.dart';
import 'package:flutter/services.dart';

class ChannelCheckingManager {
  ChannelCheckingManager();

  factory ChannelCheckingManager.initial() => ChannelCheckingManager();

  //call to native shared.
  Future<Null> actionTrackingEvent(String groupName, String sourceName, String actionName, String label) async {

    final dict = Map<String, dynamic>();
    dict['groupName'] = groupName;
    dict['sourceName'] = sourceName;
    dict['actionName'] = actionName;
    dict['label'] = label;

    try {
      //call to native
      await Config.platformChannel.invokeMethod('actionTrackingEvent', [dict]);
    } on PlatformException catch (e) {
      print('actionTrackingEvent fail ${e}');
    }
  }

  Future<Null> actionTrackingScreen(String screenName) async {

    final dict = Map<String, dynamic>();
    dict['screenName'] = screenName;

    try {
      //call to native
      await Config.platformChannel.invokeMethod('actionTrackingScreen', [dict]);
    } on PlatformException catch (e) {
      print('actionTrackingScreen fail ${e}');
    }
  }

  Future<Null> actionTrackingEcommerce(String actionName, String status) async {

    final dict = Map<String, dynamic>();
    dict['actionName'] = actionName;
    dict['status'] = status;

    try {
      //call to native
      await Config.platformChannel.invokeMethod('actionTrackingEcommerce', [dict]);
    } on PlatformException catch (e) {
      print('actionTrackingEcommerce fail ${e}');
    }
  }

}
