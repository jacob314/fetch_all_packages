import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


typedef void YoutubePlayerCreatedCallback(YoutubePlayerViewController controller);


class YoutubePlayerView extends StatefulWidget {
  const YoutubePlayerView({Key key, this.onYoutubePlayerCreated,}) : super(key: key);
  final YoutubePlayerCreatedCallback onYoutubePlayerCreated;

  @override
  State<StatefulWidget> createState() => _YoutubePlayerViewState();
}


class _YoutubePlayerViewState extends State<YoutubePlayerView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(viewType: 'plugins.plugin.com/flutterpluginyoutubeplayer',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onYoutubePlayerCreated == null) {
      return;
    }
    widget.onYoutubePlayerCreated(new YoutubePlayerViewController._(id));
  }
}


class YoutubePlayerViewController {
  YoutubePlayerViewController._(int id) : _channel = new MethodChannel('plugins.plugin.com/flutterpluginyoutubeplayer_$id');

  final MethodChannel _channel;

  Future<void> setText(String text) async {
    assert(text != null);
    return _channel.invokeMethod('setText', text);
  }

}