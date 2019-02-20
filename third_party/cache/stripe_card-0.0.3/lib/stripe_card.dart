import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

typedef void StripeWidgetCreatedCallback(StripeController controller);

class StripeCard extends StatefulWidget {
  const StripeCard({
    Key key,
    this.info,
    this.onStripeWidgetCreated,
  }) : super(key: key);
  final StripeWidgetCreatedCallback onStripeWidgetCreated;
  final Map<String, dynamic> info;
  @override
  StripeCardState createState() => new StripeCardState();
}

class StripeCardState extends State<StripeCard> with WidgetsBindingObserver{

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {

      return AndroidView(
        viewType: 'stripe_card',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.info,
        creationParamsCodec: new StandardMessageCodec(),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: "stripe_card",
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.info["publishKey"],
        creationParamsCodec: new StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onStripeWidgetCreated == null) {
      return;
    }
    widget.onStripeWidgetCreated(new StripeController._(id));
  }
}

class StripeController {

  StripeController._(int id)
      : _channel = new MethodChannel('stripe_card_$id');

  final MethodChannel _channel;

  Future<bool> validation() async {
    final bool isValid = await _channel.invokeMethod('validate');
    return isValid;
  }

  Future<String> createToken() async {
    final String token = await _channel.invokeMethod('createToken');
    return token;
  }

}