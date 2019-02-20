import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void VoiceRecognitionWidgetCreatedCallback(VoiceRecognitionController  controller);

class VoiceRecognition extends StatefulWidget {
  const VoiceRecognition({
    Key key,
    this.onVoiceRecognitionCreated,
  }) : super(key: key);

  final VoiceRecognitionWidgetCreatedCallback onVoiceRecognitionCreated;
  @override
  VoiceRecognitionState createState() => new VoiceRecognitionState();
}

class VoiceRecognitionController {

  VoiceRecognitionController ._(int id)
      : _channel = new MethodChannel('voice_recognition_$id');

  final MethodChannel _channel;

  startListening() {
    _channel.invokeMethod("voice.start");
  }

  stopListening() {
    _channel.invokeMethod("voice.stop");
  }

  setHandler(Future<dynamic> handler(MethodCall call)) {
    _channel.setMethodCallHandler(handler);
  }

}

class VoiceRecognitionState extends State<VoiceRecognition> with WidgetsBindingObserver{

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'voice_recognition',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: null,
        creationParamsCodec: new StandardMessageCodec(),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: "voice_recognition",
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: null,

        creationParamsCodec: new StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onVoiceRecognitionCreated == null) {
      return;
    }
    widget.onVoiceRecognitionCreated(new VoiceRecognitionController._(id));
  }
}