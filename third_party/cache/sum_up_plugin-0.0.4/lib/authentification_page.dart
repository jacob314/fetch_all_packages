import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class AuthPage extends StatefulWidget {
  final String authUrl;
  final String clientId;
  final String clientSecret;

  AuthPage({this.authUrl, this.clientId, this.clientSecret});

  @override
  AuthPageState createState() {
    return new AuthPageState(
        authUrl: this.authUrl,
        clientId: this.clientId,
        clientSecret: this.clientSecret);
  }
}

class AuthPageState extends State<AuthPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  final String authUrl;
  final String clientId;
  final String clientSecret;

  AuthPageState({this.authUrl, this.clientId, this.clientSecret});

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  String authorizationCode;

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      print("destroy");
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      print("onStateChanged: ${state.type} ${state.url}");
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print("URL changed: $url");
          if (url.startsWith("http://localhost:")) {
            RegExp regExp = new RegExp("code=(.*)");
            this.authorizationCode = regExp.firstMatch(url)?.group(1);
            Navigator.of(context).pop(this.authorizationCode);
            flutterWebviewPlugin.close();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WebviewScaffold(
        url: this.authUrl,
        appBar: new AppBar(
          title: new Text("SumUp"),
        ));
  }
}
