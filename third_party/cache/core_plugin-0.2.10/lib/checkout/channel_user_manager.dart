import 'dart:async';
import 'package:flutter/services.dart';
import 'package:core_plugin/config.dart';

class ChannelCheckoutManager {
  ChannelCheckoutManager();

  factory ChannelCheckoutManager.initial() => ChannelCheckoutManager();

  Future<Map<String, dynamic>> getMapCheckoutInfo() async {
    try {
      //call to native
      final Map<dynamic, dynamic> result = await Config.platformChannel.invokeMethod('checkoutInfo');
      Map<String, dynamic> json =  new Map<String, dynamic>.from(result);
      print('result: $result');
      return json;
    } on PlatformException catch (e) {
      print('loi me no roi; $e');
      return null;
    }
  }

}
