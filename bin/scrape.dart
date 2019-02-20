import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pool/pool.dart';

const totalPackages = 100000;
final _client = http.Client();
final _downloadPool = Pool(10);

void main(List<String> arguments) async {
  _clean('download');
  _downloadLatest();
}

void _clean(String dirPath) {
  var directory = Directory(dirPath);
  if (directory.existsSync()) directory.deleteSync(recursive: true);
  directory.createSync(recursive: true);
}

void _downloadLatest() async {
  // Iterate through the pages (which are in most recent order) until we get 
  // enough packages.
  var packagePage = 'http://pub.dartlang.org/api/packages';
  var index = 1;
  while (packagePage != null) { 
    var packages = jsonDecode((await _client.get(packagePage)).body);
    for (var package in packages['packages']) {
      final name = package['name'] as String;
      var latest = package['latest'];
      assert (latest != null);
      var pubspec = latest['pubspec'];
      assert (pubspec != null);
      var dependencies = pubspec['dependencies'];
      if (dependencies?.containsKey('flutter') != true) {
        print('Skipping $name as it does not use flutter');
        continue;
      }
      print('Package $name uses flutter');
      var thisIndex = index;
      _downloadPool.withResource(() async {
        var version = package['latest']['version'] as String;
        var archiveUrl = package['latest']['archive_url'] as String;

        await _download(thisIndex, name, version, archiveUrl);
      });
      index++;
      if (index > totalPackages) return;
    }
    packagePage = packages['next_url'];
  }
}

Future _download(int index, String name, String version, String url) async {
  var prefix = '[${index.toString().padLeft(5)}]';
  print('$prefix Downloading $url...');
  try {
    var response = await _client.get(url);
    var tarFile = 'download/$name-$version.tar.gz';
    await File(tarFile).writeAsBytes(response.bodyBytes);
    var outputDir = 'download/$name-$version';
    await Directory(outputDir).create(recursive: true);
    var result = await Process.run('tar', ['-xf', tarFile, '-C', outputDir]);
    if (result.exitCode != 0) {
      print('$prefix Could not extract $tarFile:\n${result.stderr}');
    } else {
      print('$prefix Extracted $outputDir');
      await File(tarFile).delete();
    }
  } catch (error) {
    print('$prefix Error downloading $url:\n$error');
  }
}
