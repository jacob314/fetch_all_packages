import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';


class FireRecorder {
  static const MethodChannel _channel =
      const MethodChannel('fire_recorder');

  static Future start({String path, AudioOutputFormat audioOutputFormat}) async {
    String extension;
    if (path != null) {
      if (audioOutputFormat != null) {
        if (_convertStringInAudioOutputFormat(p.extension(path)) != audioOutputFormat) {
          extension = _convertAudioOutputFormatInString(audioOutputFormat);
          // path += extension;
        } else {
          extension = p.extension(path);
        }
      } else {
        if (_isAudioOutputFormat(p.extension(path))) {
          extension = p.extension(path);
        } else {
          extension = ".m4a"; // default value
          // path += extension;
        }
      }
      File file =  new File(path);
      if (await file.exists()) {
        throw new Exception("A file already exists at the path :" + path);
      } else if (!await file.parent.exists()) {
        throw new Exception("The specified parent directory does not exist");
      }
    } else {
      extension = ".m4a"; // default value
    }
    return _channel.invokeMethod('start', {"path" : path, "extension" : extension});
  }

  static Future<String> stop() async {
    String response = await _channel.invokeMethod('stop');
    // Recording recording = new Recording(duration: new Duration(milliseconds: response['duration']), path: response['path'],audioOutputFormat: _convertStringInAudioOutputFormat(response['audioOutputFormat']), extension: response['audioOutputFormat']);
    // return recording;
    return response;
  }

  static Future<bool> isRecording() async {
      var ir = _channel.invokeMethod('isRecording');
      return ir;
  }

  // static Future<bool> get hasPermissions =>
  //     _channel.invokeMethod('hasPermissions');

  static AudioOutputFormat _convertStringInAudioOutputFormat(String extension) {
    switch (extension) {
      case ".mp4":
      case ".aac":
      case ".m4a":
        return AudioOutputFormat.AAC;
      default :
        return null;
    }
  }

  static bool _isAudioOutputFormat(String extension) {
    switch (extension) {
      case ".mp4":
      case ".aac":
      case ".m4a":
        return true;
      default :
        return false;
    }
  }

  static String _convertAudioOutputFormatInString(AudioOutputFormat outputFormat){
    switch (outputFormat) {
      case AudioOutputFormat.AAC:
        return ".m4a";
      default :
        return ".m4a";
    }
  }
}

enum AudioOutputFormat {
  AAC,
}

class Recording {
  // File path
  String path;
  // File extension
  String extension;
  // Audio duration in milliseconds
  Duration duration;
  // Audio output format
  AudioOutputFormat audioOutputFormat;

  Recording({this.duration, this.path,this.audioOutputFormat,this.extension});
}
