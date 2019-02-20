import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class Fluqq {
  static const MethodChannel _channel =
      const MethodChannel('fluqq');


  static Future<void> register(String androidAppId, String iOSAppId) async {
    await _channel.invokeMethod('register', {'androidAppId': androidAppId, 'iOSAppId': iOSAppId});
  }

  static Future<QQResult> login() async {
    final Map<dynamic, dynamic> result = await _channel.invokeMethod('login');
    QQResult qqResult = new QQResult();
    qqResult.status = result["status"];
    qqResult.msg = result["msg"].toString();
    return qqResult;
  }

  static Future<QQResult> userInfo(Tencent tencent) async {
    final Map<dynamic, dynamic> result = await _channel.invokeMethod('userInfo', {'openId': tencent.openId, 'accessToken': tencent.accessToken, 'expiresTime': tencent.expiresTime});
    QQResult qqResult = new QQResult();
    qqResult.status = result["status"];
    qqResult.msg = result["msg"].toString();
    return qqResult;
  }

}

class QQResult {
  int status;
  String msg;
}

class Tencent {
  String openId;
  String accessToken;
  int expiresTime;

  Tencent({
    this.openId,
    this.accessToken,
    this.expiresTime,
  });

  static Tencent fromJson(String jsonStr) {
    var json = JsonDecoder().convert(jsonStr);
    return Tencent(
      openId: json['openid'],
      accessToken: json['access_token'],
      expiresTime: json['expires_time'],
    );
  }
}