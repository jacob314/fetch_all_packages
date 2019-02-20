import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void CameraViewCreatedCallback(CameraViewController controller);

class CameraView extends StatefulWidget {
  CameraView({
    Key key,
    this.onCameraViewCreated,
  }) : super(key: key);

  final CameraViewCreatedCallback onCameraViewCreated;
  CameraViewController _controller;
  CameraViewController get controller => _controller;

  @override
  State<StatefulWidget> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraViewController _cameraController;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: AndroidView(
          viewType: 'com.invariance.camsnapplugin/cameraview',
          onPlatformViewCreated: _onPlatformViewCreated,
        ));
    }
    return Text(
      '$defaultTargetPlatform is not yet supported by the camsnap plugin');
  }

  void _onPlatformViewCreated(int id) {
    print('============== View created: $id');
    _cameraController = new CameraViewController._(id);
    widget._controller = _cameraController;
    if (widget.onCameraViewCreated == null) {
      return;
    }
    widget.onCameraViewCreated(_cameraController);
  }
}

class CameraViewController {
  CameraViewController._(int id) : _channel = new MethodChannel('com.invariance.camsnapplugin/cameraview_$id');

  final MethodChannel _channel;

  Future<dynamic> captureImage(String location, String fileName) async {
    assert(location != null);
    assert(fileName != null);
    return _channel.invokeMethod('captureImage', [location, fileName]);
  }

  void enablePreview() async {
    _channel.invokeMethod('enablePreview');
  }

  void disablePreview() async {
    _channel.invokeMethod('disablePreview');
  }
}