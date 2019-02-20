export './ocr_result.dart';
export './liveness_result.dart';
export './idauth_result.dart';
export './compare_result.dart';
export './error_result.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import './ocr_result.dart';
import './liveness_result.dart';
import './idauth_result.dart';
import './compare_result.dart';
import './error_result.dart';

class UdidPlugin {
  factory UdidPlugin() => _instance ??= UdidPlugin._();

  UdidPlugin._() {
    _channel.setMethodCallHandler(_handleMessages);
  }

  static UdidPlugin _instance;

  Stream<ErrorResut> get errorStream => _errorController.stream;
  StreamController _errorController = StreamController<ErrorResut>.broadcast();

  static const MethodChannel _channel = const MethodChannel('udid_plugin');

  Future<Null> _handleMessages(MethodCall call) async {
    switch (call.method) {
      case 'errorResult':
        _errorController.add(ErrorResut.fromJson(call.arguments));
        break;
    }
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // OCR 身份证扫描
  Future<OcrResut> startOCRFlow(Map<String, dynamic> engineArg) async {
    final Map<dynamic, dynamic> result =
        await _channel.invokeMethod('startOCRFlow', engineArg);
    return new OcrResut.fromJson(result);
  }

  // 活体检测
  Future<LivenessResult> startLivenessFlow(
      Map<String, dynamic> engineArg) async {
    final Map<dynamic, dynamic> result =
        await _channel.invokeMethod('startLivenessFlow', engineArg);
    return new LivenessResult.fromJson(result);
  }

  // 实名验证
  Future<IdAuthResut> startIDAuthFlow(Map<String, dynamic> engineArg) async {
    final Map<dynamic, dynamic> result =
        await _channel.invokeMethod('startIDAuthFlow', engineArg);
    return new IdAuthResut.fromJson(result);
  }

  // 比对
  Future<CompareResut> startCompareFlow(Map<String, dynamic> engineArg) async {
    final Map<dynamic, dynamic> result =
        await _channel.invokeMethod('startCompareFlow', engineArg);
    return new CompareResut.fromJson(result);
  }

  // 视频存证
  Future<Map> startVideoFlow(Map<String, dynamic> engineArg) async {
    final Map result = await _channel.invokeMethod('startVideoFlow', engineArg);
    return result;
  }

  // 自由组合流程
  Future<Map> startCustomFlow(Map<String, dynamic> engineArg) async {
    final Map result =
        await _channel.invokeMethod('startCustomFlow', engineArg);
    return result;
  }

  /// Close all Streams
  void dispose() {
    _errorController.close();
    _instance = null;
  }
}
