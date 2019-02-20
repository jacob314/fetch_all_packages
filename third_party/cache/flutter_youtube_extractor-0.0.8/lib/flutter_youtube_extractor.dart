import 'package:flutter/services.dart';

class FlutterYoutubeExtractor {
  static const MethodChannel _nativeChannel =
      const MethodChannel('flutter.youtube.extractor/native');

  static void getYoutubeMediaLink({
    String youtubeLink,
    Function(String mediaLink) onReceive,
  }) {
    var _link = '';

    if (youtubeLink.startsWith('https://www.youtube.com')) {
      if (youtubeLink.contains('watch?v='))
        _link = youtubeLink;
      else if (youtubeLink.contains('embed'))
        _link =
            'https://www.youtube.com/watch?v=${youtubeLink.substring(youtubeLink.indexOf('embed/') + 6)}';
      print('~> $_link');
      _nativeChannel.invokeMethod('getYoutubeMediaLink', _link);
    } else
      onReceive('Unknown');

    _nativeChannel.setMethodCallHandler((MethodCall call) {
      switch (call.method) {
        case 'receiveYoutubeMediaLink':
          onReceive(call.arguments);
          break;
      }
    });
  }

  static void requestRotateScreen({bool isLandscape}) {
    _nativeChannel.invokeMethod('requestRotateScreen', isLandscape);
  }
}
