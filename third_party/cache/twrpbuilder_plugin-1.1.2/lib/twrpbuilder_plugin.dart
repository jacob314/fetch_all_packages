import 'dart:async';

import 'package:flutter/services.dart';

class TwrpbuilderPlugin {
  static const MethodChannel _channel =
      const MethodChannel('twrpbuilder_plugin');

  static Future<bool> get rootAccess async {
    final bool access = await _channel.invokeMethod('isAccessGiven');
    return access;
  }

  static Future<String> mkDir(String directory) async {
    final String makeDir =
        await _channel.invokeMethod('mkdir', <String, dynamic>{
      'dir': directory,
    });
    return makeDir;
  }

  static Future<String> command(String command) async {
    final String commandLog =
        await _channel.invokeMethod('command', <String, dynamic>{
      'command': command,
    });
    return commandLog;
  }

  static Future<String> suCommand(String command) async {
    final String commandLog =
        await _channel.invokeMethod('suCommand', <String, dynamic>{
      'command': command,
    });
    return commandLog;
  }

  static Future<String> cp(String src, String dest) async {
    final String commandLog = await _channel
        .invokeMethod('cp', <String, dynamic>{'src': src, 'dest': dest});
    return commandLog;
  }

  static Future<bool> compressGzipFile(String file, String gzipFile) async {
    final bool status = await _channel.invokeMethod('compressGzipFile',
        <String, dynamic>{'file': file, 'gZipFile': gzipFile});
    return status;
  }

  static Future<Object> zip(String files, String zipFile) async {
    await _channel.invokeMethod('zip',
        <String, dynamic>{'files': files, 'zipFile': zipFile});
    return null;
  }

  static Future<Null> createBuildProp(String filename, String data) async {
    return await _channel.invokeMethod('createBuildProp',
        <String, dynamic>{'filename': filename, 'data': data});
  }

  static Future<String> get getBuildModel async {
    return await _channel.invokeMethod('getBuildModel');
  }

  static Future<String> get getBuildFingerprint async {
    return await _channel.invokeMethod('getBuildFingerprint');
  }

  static Future<String> get getBuildProduct async {
    return await _channel.invokeMethod('getBuildProduct');
  }

  static Future<String> get getBuildBrand async {
    return await _channel.invokeMethod('getBuildBrand');
  }

  static Future<String> get getBuildBoard async {
    return await _channel.invokeMethod('getBuildBoard');
  }

  static Future<String> get getBuildAbi async {
    return await _channel.invokeMethod('getBuildAbi');
  }

  static Future<String> get getSdCard async {
    return await _channel.invokeMethod('getSdCard');
  }

  static Future<String> get buildProp async {
    return await _channel.invokeMethod('buildProp');
  }

  static Future<bool> get isOldMtk async {
    return await _channel.invokeMethod('isOldMtk');
  }

  static Future<String> getRecoveryMount() async {
    final String path = await _channel.invokeMethod('getRecoveryMount');
    return path;
  }
}
