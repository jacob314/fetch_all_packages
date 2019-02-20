library mattcorp_login;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MattCorpLogin {
  MattCorpLogin({this.client});
  final String client;

  Future<String> login(BuildContext context) async {
    Completer<String> response = new Completer();

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new _LoginScreen(completer: response, client: client)));

    return response.future;
  }
}

class _LoginScreen extends StatefulWidget {
  _LoginScreen({this.client, this.completer});

  final Completer<String> completer;
  final String client;

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;

  bool _returned;

  void _return({token = ""}) {
    if (!_returned) {
      _returned = true;

      if (token.length > 0) {
        widget.completer.complete(token);
      } else {
        widget.completer.completeError("User cancelled");
      }

      flutterWebviewPlugin.dispose();
    }
  }

  @override
  initState() {
    super.initState();

    _returned = false;

    flutterWebviewPlugin.close();

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        _return();
        Navigator.pop(context);
      }
    });

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        if (url.startsWith('https://mattcorp.com')) {
          final Uri uri = Uri.parse(url);
          final String token = uri.queryParameters["token"];
          _return(token: token);
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url:
          "https://id.mattcorp.com/jwt?embed=true&client=${widget.client}&return=https%3A%2F%2Fmattcorp.com",
      appBar: new AppBar(title: new Text("MattCorp Login")),
      clearCookies: true,
      clearCache: true,
    );
  }

  @override
  void dispose() {
    _onDestroy.cancel();
    _onUrlChanged.cancel();

    _return();

    super.dispose();
  }
}
