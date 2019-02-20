import 'dart:async';
import 'package:flutter/services.dart';
import 'package:core_plugin/config.dart';

class ChannelUserManager {
  ChannelUserManager();

  factory ChannelUserManager.initial() => ChannelUserManager();

  //call to native login.
  Future<bool> actionLogin(String screenName) async {

    final dict = Map<String, dynamic>();
    dict['screenName'] = screenName;

    try {
      //call to native
      final bool result = await Config.platformChannel.invokeMethod('actionLoginEvent', [dict]);
      return result;
    } on PlatformException catch (e) {
      print('actionLoginEvent fail $e');
      return false;
    }
  }

  Future<bool> actionLogout() async {

    final dict = Map<String, dynamic>();

    try {
      //call to native
      final bool result = await Config.platformChannel.invokeMethod('actionLogoutEvent', [dict]);
      return result;
    } on PlatformException catch (e) {
      print('actionLogoutEvent fail $e');
      return false;
    }
  }

  Future<String> getUserInfo() async {
    try {
      //call to native
      final String result = await Config.platformChannel.invokeMethod('userInfo');
      print('result: $result');
      return result;
    } on PlatformException catch (e) {
      print('loi me no roi; $e');
      return "";
    }
  }

  Future<Map<String, dynamic>> getMapUserInfo() async {
    try {
      //call to native
      final Map<dynamic, dynamic> result = await Config.platformChannel.invokeMethod('userMapInfo');
      Map<String, dynamic> json =  new Map<String, dynamic>.from(result);
      print('result: $result');
      return json;
    } on PlatformException catch (e) {
      print('loi me no roi; $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getCheckoutInfo() async {
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
