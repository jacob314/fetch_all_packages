import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show instantiateImageCodec, Codec;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TTImageProvider extends ImageProvider<TTImageInfo> {
  final TTImageInfo _imageInfo;
  final MethodChannel _methodChannel;

  TTImageProvider(String url, this._methodChannel, {
    List<String> urlList,
    Map<String, String> headers
  }) : _imageInfo = TTImageInfo(url, urlList: urlList);

  TTImageInfo get imageInfo => _imageInfo;

  @override
  ImageStream resolve(ImageConfiguration configuration) {
    assert(configuration != null);
    final ImageStream stream = new ImageStream();
    TTImageInfo obtainedKey;
    obtainKey(configuration).then<void>((TTImageInfo key) {
      obtainedKey = key;
      stream.setCompleter(load(key));
    }).catchError(
            (dynamic exception, StackTrace stack) async {
          FlutterError.reportError(new FlutterErrorDetails(
              exception: exception,
              stack: stack,
              library: 'services library',
              context: 'while resolving an image',
              silent: true, // could be a network error or whatnot
              informationCollector: (StringBuffer information) {
                information.writeln('Image provider: $this');
                information.writeln('Image configuration: $configuration');
                if (obtainedKey != null)
                  information.writeln('Image key: $obtainedKey');
              }
          ));
          return null;
        }
    );
    return stream;
  }

  @override
  ImageStreamCompleter load(TTImageInfo key) {
    return new MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: 1.0,
        informationCollector: (StringBuffer information) {
          information.writeln('Image provider: $this');
          information.write('Image key: $key');
        });
  }

  @override
  Future<TTImageInfo> obtainKey(ImageConfiguration configuration) {
    return new SynchronousFuture<TTImageInfo>(_imageInfo);
  }

  Future<ui.Codec> _loadAsync(TTImageInfo key) async {

    final Map<String, dynamic> args = <String, dynamic>{
      "url": key.url,
      "url_list": key.urlList
    };
    try {
      final Uint8List bytes = await _methodChannel.invokeMethod(
          "fetchImage", args);
      return await ui.instantiateImageCodec(bytes);
    } on Exception catch(e) {
      print(e);
    }
    return null;
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType)
      return false;
    final TTImageProvider info = other;
    return this.imageInfo == info.imageInfo;
  }

  @override
  int get hashCode => this.imageInfo.hashCode;


}

class TTImageInfo {
  final String url;
  final List<String> urlList;

  const TTImageInfo(
    this.url, {
    this.urlList,
  });

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType)
      return false;
    final TTImageInfo info = other;
    return url == info.url;
  }

  @override
  int get hashCode {
    return url.hashCode;
  }
}
