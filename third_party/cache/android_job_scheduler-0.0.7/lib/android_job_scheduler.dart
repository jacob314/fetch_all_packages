import 'dart:async';

import 'package:flutter/services.dart';
import './src/constraints.dart';
import './src/utils.dart';

export './src/constraints.dart';

class AndroidJobInfo {
  int id;
  AndroidJobInfo(this.id);
}

class _ScheduleOnceConstraint extends JobConstraint {
  const _ScheduleOnceConstraint();
  String getName() => "ScheduleOnceConstraint";
  Map<String, dynamic> serialize () => {};
}

class AndroidJobScheduler {
  static const MethodChannel _channel =
      const MethodChannel('plugins.gjg.io/android_job_scheduler');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> _schedule(Duration every, int id, dynamic Function() function, {persistentAcrossReboots = false, List<JobConstraint> constraints}) async {
    _channel.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case 'firedWhileApplicationRunning':
          function();
          return;
        default:
          throw 'not implemented';
      }
    });
    final String functionName = _getFunctionName(function);
    if (functionName == null) {
      throw 'scheduleEvery failed: The supplied function can only be a top level function or a static method! Class members'
          ' or Closures are not allowed.';
    }
    if (constraints == null && persistentAcrossReboots) {
      constraints = [ const PersistentAcrossReboots() ];
    } else if (constraints != null && persistentAcrossReboots) {
      constraints.add(const PersistentAcrossReboots());
    }
    return await _channel.invokeMethod('scheduleEvery', [every.inMilliseconds, functionName, id, serializeConstraints(constraints)]);
  }

  static Future<bool> scheduleOnce(Duration once, int id, dynamic Function() function, {persistentAcrossReboots = false, List<JobConstraint> constraints}) async {
    if (constraints == null) {
      constraints = [ const _ScheduleOnceConstraint() ];
    } else {
      constraints.add(const _ScheduleOnceConstraint());
    }
    return _schedule(once, id, function, persistentAcrossReboots: persistentAcrossReboots, constraints: constraints);
  }

  static Future<bool> scheduleEvery(Duration every, int id, dynamic Function() function, {persistentAcrossReboots = false, List<JobConstraint> constraints}) async {
    return _schedule(every, id, function, persistentAcrossReboots: persistentAcrossReboots, constraints: constraints);
  }

  static Future<void> cancelJob(int id) async {
    return await _channel.invokeMethod('cancelJob', [id]);
  }

  static Future<void> cancelAllJobs() async {
    return await _channel.invokeMethod('cancelAllJobs', []);
  }

  static Future<List<AndroidJobInfo>> getAllPendingJobs() async {
    return (await _channel.invokeMethod('getAllPendingJobs', []) as List<dynamic>)
      .cast<int>().map((int id) => new AndroidJobInfo(id)).toList();
  }
}

String _getFunctionName(dynamic Function() function) {
  final String s = function.toString();
  try {
    return s.substring(s.indexOf('\'') + 1, s.lastIndexOf('\''));
  } on RangeError {
    return null;
  }
}
