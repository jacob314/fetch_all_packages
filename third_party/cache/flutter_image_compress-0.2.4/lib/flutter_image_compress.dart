import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

/// Image Compress
///
/// static method will help you compress image
///
/// most method will return [List<int>]
///
/// convert List<int> to [Uint8List] and use [Image.memory(uint8List)] to display image
/// ```dart
/// var u8 = Uint8List.fromList(list)
/// ImageProvider provider = MemoryImage(Uint8List.fromList(list));
/// ```
///
/// The returned image will retain the proportion of the original image.
///
/// Compress image will remove EXIF.
///
/// image result is jpeg format.
///
/// support rotate
///
class FlutterImageCompress {
  static const MethodChannel _channel = const MethodChannel('flutter_image_compress');

  /// compress image from [List<int>] to [List<int>]
  static Future<List<int>> compressWithList(
    List<int> image, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
  }) async {
    final result = await _channel.invokeMethod("compressWithList", [
      Uint8List.fromList(image),
      minWidth,
      minHeight,
      quality,
      rotate,
    ]);

    return convertDynamic(result);
  }

  /// compress file of [path] to [List<int>]
  static Future<List<int>> compressWithFile(
    String path, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
  }) async {
    final result = await _channel.invokeMethod("compressWithFile", [
      path,
      minWidth,
      minHeight,
      quality,
      rotate,
    ]);
    return convertDynamic(result);
  }

  /// from [path] to [targetPath]
  static Future<File> compressAndGetFile(
    String path,
    String targetPath, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
  }) async {
    if (!File(path).existsSync()) {
      return null;
    }

    final String result = await _channel.invokeMethod("compressWithFileAndGetFile", [
      path,
      minWidth,
      minHeight,
      quality,
      targetPath,
      rotate,
    ]);

    return File(result);
  }

  /// from [asset] to [List<int>]
  static Future<List<int>> compressAssetImage(
    String assetName, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
  }) async {
    var img = AssetImage(assetName);
    var config = new ImageConfiguration();

    AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);

//    print(data.buffer.asUint8List().length);

    return compressWithList(
      data.buffer.asUint8List(),
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
      rotate: rotate,
    );
  }
  // static Future<List<int>> compressWithImage(BuildContext context, Image image,
  //     {int minWidth = 1920, int minHeight = 1080, int quality = 95}) async {
  //   var info = await getImageInfo(context, image.image);
  //   var data = await info.image.toByteData(format: ImageByteFormat.png);
  //   var list = data.buffer.asUint8List().toList();
  //   // print(list);
  //   var result = await compressWithList(
  //     list,
  //     minWidth: minWidth,
  //     minHeight: minHeight,
  //     quality: quality,
  //   );
  //   print(result.length);
  //   return [];
  // }

  // static Future<List<int>> _compressWithImageProvider(
  //     BuildContext context, ImageProvider provider,
  //     {int minWidth = 1920, int minHeight = 1080, int quality = 95}) async {
  //   var info = await getImageInfo(context, provider);
  //   var data = await info.image.toByteData();
  //   var list = data.buffer.asUint8List().toList();

  //   return compressWithList(
  //     list,
  //     minWidth: minWidth,
  //     minHeight: minHeight,
  //     quality: quality,
  //   );
  // }

  /// convert [List<dynamic>] to [List<int>]
  static List<int> convertDynamic(List<dynamic> list) {
    return list.where((item) => item is int).map((item) => item as int).toList();
  }
}

/// get [ImageInfo] from [ImageProvider]
Future<ImageInfo> getImageInfo(BuildContext context, ImageProvider provider, {Size size}) async {
  final ImageConfiguration config = createLocalImageConfiguration(context, size: size);
  final Completer<ImageInfo> completer = new Completer<ImageInfo>();
  final ImageStream stream = provider.resolve(config);
  void listener(ImageInfo image, bool sync) {
    completer.complete(image);
  }

  void errorListener(dynamic exception, StackTrace stackTrace) {
    completer.complete(null);
    FlutterError.reportError(new FlutterErrorDetails(
      context: 'image load failed ',
      library: 'flutter_image_compress',
      exception: exception,
      stack: stackTrace,
      silent: true,
    ));
  }

  stream.addListener(listener, onError: errorListener);
  completer.future.then((ImageInfo info) {
    stream.removeListener(listener);
  });
  return completer.future;
}
