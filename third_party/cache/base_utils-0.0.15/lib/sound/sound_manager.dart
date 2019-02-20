import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SoundManager {
  static AudioPlayer audioPlayer = new AudioPlayer();

  static bool _enabled = true;

  static bool get isEnabled => _enabled;

  static final _filesMap = Map<String,File>();

  static var duration = Duration();

  static final interval = Duration(milliseconds: 500);

  static Timer timer;

  static void setEnabled(bool enabled) {
    assert(enabled != null);
    _enabled = enabled;
    if(!enabled){
      audioPlayer.pause();
    } else {
      audioPlayer.resume();
      audioPlayer.seek(duration);
    }
  }

  static Future init(List<String> fileNames, {String package}) async {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
    fileNames.forEach((localFileName) async {
      await load(localFileName, package: package);
    });
  }

  static Future<File> load(localFileName, {String package}) async{
    final dir = await getApplicationDocumentsDirectory();
    final file = new File("${dir.path}/$localFileName");
    final assetPath = generateAssetPath(localFileName, package);
    if (!(await file.exists())) {
      final soundData = await rootBundle.load(assetPath);
      final bytes = soundData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }
    _filesMap[assetPath] = file;
    return file;
  }

  static String generateAssetPath(String localFileName, String package) => "packages/$package/assets/$localFileName";

  static Future play(String localFileName, {String package}) async {

    duration = Duration();

    cancelTimer();

    timer = Timer.periodic(interval, (timer){
      duration += interval;
    });

    audioPlayer.completionHandler = (){
      cancelTimer();
    };

    final assetPath = generateAssetPath(localFileName, package);

    if(!_filesMap.containsKey(assetPath)){
      await load(localFileName, package: package);
    }

    audioPlayer.stop();

    await audioPlayer.play(_filesMap[assetPath].path, isLocal: true);

    if(!_enabled){
      audioPlayer.pause();
    }
  }

  static void stop() {
    audioPlayer.stop();
    cancelTimer();
  }

  static void cancelTimer() {
    if(timer != null){
      timer.cancel();
    }
  }

}