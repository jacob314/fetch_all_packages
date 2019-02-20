import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:dart_config/default_server.dart';

const String buildGradleFile = "android/app/build.gradle";
const String infoPlistFile = "ios/Runner/Info.plist";

RegExp semanticVersionRegex = new RegExp(r"^\d+.\d+.\d+$");
RegExp numOnlyRegex = new RegExp(r"^\d+$");

main(List<String> arguments) {
  Future<Map> conf = loadConfig("pubspec.yaml");
  conf.then((Map config) {
    if (config['flutter_version']['version_string'] != null) {
      //validate version
      if(isValidVersion(config['flutter_version']['version_string'])) {
        //update android build.gradle
        updateAndroid(config['flutter_version']['version_string']);
        //update ios Info.plist
        updateIos(config['flutter_version']['version_string']);
      }
    } else {
      print("No version config found in pubspec.yaml");
    }
  });
}

bool isValidVersion(String s) {
  return semanticVersionRegex.hasMatch(s);
}

updateAndroid(String versionString) {
  final file = new File(buildGradleFile);
  Stream<List<int>> inputStream = file.openRead();
  StringBuffer fileOutput = new StringBuffer();

  inputStream.transform(UTF8.decoder).transform(new LineSplitter()).listen((String line) {
    //find version code
    if(line.trim().startsWith("versionCode")) {
      int versionCode = int.parse(line.trim().split(" ").elementAt(1));
      print("Found version code: " + versionCode.toString());
      //increment version code
      line = line.substring(0, line.length - versionCode.toString().length);
      versionCode++;
      line = line + versionCode.toString();
      print("Line with new version code: " + line);
      fileOutput.writeln(line);

    } else if(line.trim().startsWith("versionName")) {
      String oldVersion = line.trim().split(" ").elementAt(1);
      print("Found version name:" + oldVersion);
      line = line.substring(0, line.length - oldVersion.length);
      line = line + "\"" + versionString + "\"";
      print("Line with new version name: " + line);
      fileOutput.writeln(line);
    } else {
      fileOutput.writeln(line);
    }
  }, onDone: () {
    print("build.gradle updated!");
    new File(buildGradleFile).writeAsString(fileOutput.toString());
    },
  );
}

updateIos(String versionString) {
  final file = new File(infoPlistFile);
  Stream<List<int>> inputStream = file.openRead();
  StringBuffer fileOutput = new StringBuffer();
  bool nextLineBundleVersion = false;
  bool nextLineShortVersionString = false;

  inputStream.transform(UTF8.decoder).transform(new LineSplitter()).listen((String line) {
    //find version code
    if(line.contains("CFBundleVersion")) {
      nextLineBundleVersion = true;
      fileOutput.writeln(line);
    } else if (nextLineBundleVersion) {
      String bundleVersion = line.substring(line.indexOf(">") + 1, line.lastIndexOf("<"));
      print("Found bundle version: " + bundleVersion);
      //increment bundle version
      if(numOnlyRegex.hasMatch(bundleVersion)) {
        int intVersion = int.parse(bundleVersion);
        intVersion++;
        bundleVersion = intVersion.toString();
      } else if (semanticVersionRegex.hasMatch(bundleVersion)) {
        List<String> parts = bundleVersion.split(".");
        bundleVersion = "";
        for(int i = 0; i < parts.length - 1; i++) {
          bundleVersion = bundleVersion + parts[i] + ".";
        }
        int intVersion = int.parse(parts[parts.length - 1]);
        intVersion++;
        bundleVersion = bundleVersion + intVersion.toString();
      } else {
        print("Unknown bundle version format, can't increment");
        return;
      }
      line = line.substring(0, line.indexOf("<"));
      line = line + "<string>" + bundleVersion.toString() + "</string>";

      print("Line with new bundle version: " + line);
      fileOutput.writeln(line);
      nextLineBundleVersion = false;
    } else if(line.contains("CFBundleShortVersionString")) {
      nextLineShortVersionString = true;
      fileOutput.writeln(line);
    } else if (nextLineShortVersionString) {
      String oldVersion = line.substring(line.indexOf(">") + 1, line.lastIndexOf("<"));
      print("Found version name:" + oldVersion);
      line = line.substring(0, line.indexOf("<"));
      line = line + "<string>" + versionString + "</string>";
      print("Line with new version name: " + line);
      fileOutput.writeln(line);
      nextLineShortVersionString = false;
    } else {
      fileOutput.writeln(line);
    }
  }, onDone: () {
    print("Info.plist updated!");
    new File(infoPlistFile).writeAsString(fileOutput.toString());
  },
  );
}