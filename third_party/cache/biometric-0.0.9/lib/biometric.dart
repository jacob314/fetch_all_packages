import 'dart:async';

import 'package:flutter/services.dart';

enum BiometricType { face, fingerprint, iris }

class Biometric {
  static const MethodChannel _channel =
      const MethodChannel('biometric');

  Future<bool> biometricAuthenticate({
    bool keepAlive = false,
    bool cancelOnFail = false,
  }) async {

    final Map<String, Object> args = <String, Object>{
      'keepAlive': keepAlive
    };

    return await _channel.invokeMethod('biometricAuthenticate', args);
  }

  Future<bool> biometricAvailable() async {
    return await _channel.invokeMethod('biometricAvailable');
  }

  Future<void> biometricCancel() async {
    return await _channel.invokeMethod('biometricCancel');
  }

  Future<List<BiometricType>> biometricsType() async {
    final List<String> result = (await _channel.invokeMethod('biometricType')).cast<String>();
    final List<BiometricType> biometricList = <BiometricType>[];
    result.forEach((String value) {
      switch (value) {
        case 'face':
          biometricList.add(BiometricType.face);
          break;
        case 'fingerprint':
          biometricList.add(BiometricType.fingerprint);
          break;
        case 'iris':
          biometricList.add(BiometricType.iris);
          break;
        case 'undefined':
          break;
      }
    });
    return biometricList;
  }

}
