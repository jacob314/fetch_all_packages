import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleStepHistory {
  static const MethodChannel _channel =
      const MethodChannel('simple_step_history');

  static Future<bool> requestAuthorization() async {
    final int granted = await _channel.invokeMethod('requestStepsAuthorization');
    return (granted >= 0);    
  }

  static Future<int> getStepsForDay({@required String dateStr}) async {
    final int steps = await _channel.invokeMethod('fetchSteps', dateStr);
    return steps;
  }

  static Future<bool> get isStepsAvailable async {
    final bool flag = await _channel.invokeMethod('checkStepsAvailability');
    return flag;
  }
}
