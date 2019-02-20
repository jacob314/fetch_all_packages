import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';

class FlutterMob {
  static const MethodChannel channel = const MethodChannel('flutter_mob');

  static Future<void> init(String appKey, String appSecret) async {
    await channel.invokeMethod('init', {'appKey': appKey, 'appSecret': appSecret});
  }

  static Future<Result> getCode(String phone) async {
    final Map<dynamic, dynamic> getCode = await channel.invokeMethod('getCode', {'phone': phone});
    Result result = new Result();
    result.status = getCode["status"];
    result.msg = getCode["msg"];
    return result;
  }

  static Future<Result> submitCode(String phone, String code) async {
    final Map<dynamic, dynamic> getCode = await channel.invokeMethod('submitCode', {'phone': phone, 'code': code});
    Result result = new Result();
    result.status = getCode["status"];
    result.msg = getCode["msg"];
    return result;
  }

  static Future<void> config({HashMap<String, Object> wechat, HashMap<String, Object> wechatMoments, HashMap<String, Object> qq, HashMap<String, Object> sina}) async {
    await channel.invokeMethod('config', {'wechat': wechat, 'wechatMoments': wechatMoments, 'qq': qq, 'sina': sina});
  }

  static Future<Result> qqLogin() async {
    final Map<dynamic, dynamic> login = await channel.invokeMethod('qqLogin');
    Result result = new Result();
    result.status = login["status"];
    result.msg = login["msg"];
    return result;
  }

  static Future<Result> wechatLogin() async {
    final Map<dynamic, dynamic> login = await channel.invokeMethod('wechatLogin');
    Result result = new Result();
    result.status = login["status"];
    result.msg = login["msg"];
    return result;
  }

  static Future<Result> sinaLogin() async {
    final Map<dynamic, dynamic> login = await channel.invokeMethod('sinaLogin');
    Result result = new Result();
    result.status = login["status"];
    result.msg = login["msg"];
    return result;
  }

  static Future<void> share(String title, String text, {String imagePath, String url, String titleUrl}) async {
    await channel.invokeMethod('share', {'title': title, 'text': text, 'imagePath': imagePath, 'url': url, 'titleUrl': titleUrl});
  }
}

class Result {
  int status;
  String msg;
}
