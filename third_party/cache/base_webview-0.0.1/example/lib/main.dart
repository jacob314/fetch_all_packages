import 'dart:async';

import 'package:base_webview/base_webview.dart';
import 'package:flutter/material.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://flutter.io';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter WebView Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (_) => const MyHomePage(title: 'Flutter WebView Demo'),
        '/widget': (_) => new WebviewScaffold(
              url: selectedUrl,
              appBar: new AppBar(
                title: const Text('Widget webview'),
              ),
              withZoom: true,
              withLocalStorage: true,
            )
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Instance of WebView plugin
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  StreamSubscription<String> _onUrlOverridden;

  StreamSubscription<String> _onSchemeMatched;

  final _urlCtrl = new TextEditingController(text: selectedUrl);

  final _codeCtrl =
      new TextEditingController(text: 'window.navigator.userAgent');

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _history = [];

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onScrollYChanged =
        flutterWebviewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add("Scroll in  Y Direction: $y");
        });
      }
    });

    _onScrollXChanged =
        flutterWebviewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add("Scroll in  X Direction: $x");
        });
      }
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });

    _onUrlOverridden =
        flutterWebviewPlugin.onUrlOverridden.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlOverridden: $url');
        });
      }
    });

    _onSchemeMatched =
        flutterWebviewPlugin.onSchemeMatched.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onSchemeMatched: $url');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

    flutterWebviewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Container(
              padding: const EdgeInsets.all(24.0),
              child: new TextField(controller: _urlCtrl),
            ),
            new RaisedButton(
              onPressed: () {
                flutterWebviewPlugin.launch(selectedUrl,
                    rect: new Rect.fromLTWH(
                        0.0, 0.0, MediaQuery.of(context).size.width, 300.0),
                    userAgent: kAndroidUserAgent);
              },
              child: const Text('Open Webview (rect)'),
            ),
            new RaisedButton(
              onPressed: () {
                flutterWebviewPlugin.launch(selectedUrl, hidden: true);
              },
              child: const Text('Open "hidden" Webview'),
            ),
            new RaisedButton(
              onPressed: () {
                flutterWebviewPlugin.launch(selectedUrl);
              },
              child: const Text('Open Fullscreen Webview'),
            ),
            new RaisedButton(
              onPressed: () {
                selectedUrl = 'https://google.com';
                var schemesArray = [
                  'flutter',
                  'https',
                ];

                flutterWebviewPlugin.launch(selectedUrl);
                flutterWebviewPlugin.setUriSchemes(schemesArray);
              },
              child: const Text('Open Fullscreen Webview with schemes'),
            ),
            new RaisedButton(
              onPressed: () {
                selectedUrl = 'https://google.com';
                var oerrideableArray = [
                  'google',
                  'net',
                ];

                flutterWebviewPlugin.launch(selectedUrl);
                flutterWebviewPlugin.setOverridableUrls(oerrideableArray);
              },
              child:
                  const Text('Open Fullscreen Webview with overrideable url'),
            ),
            new RaisedButton(
              onPressed: () {
                String htmlString =
                    '<html><head><title>Page Title</title></head><body><h1>My First Heading</h1><p>My first paragraph.</p></body></html>';
                flutterWebviewPlugin.launch(selectedUrl, html: htmlString);
              },
              child: const Text('Open Fullscreen Webview with html String'),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/widget');
              },
              child: const Text('Open widget webview'),
            ),
            new RaisedButton(
              onPressed: () {
                String html = """
                <div class=\"accordion-rule\"><a class=\"ctrl\" href=\"#content\" data-collapse=\"\"><strong>GI\u1edaI THI\u1ec6U<\/strong><\/a>\r\n<div id=\"other\">\u00a0<\/div>\r\n<p><strong>Sen \u0110\u1ecf<\/strong> d\u00e0nh t\u1eb7ng qu\u00fd kh\u00e1ch h\u00e0ng ch\u01b0\u01a1ng tr\u00ecnh <strong>Deal s\u1ed1c \u0111i\u1ec7n tho\u1ea1i<\/strong> v\u1edbi m\u00e3 gi\u1ea3m gi\u00e1 \u0111\u1ec3 mua \u0111i\u1ec7n tho\u1ea1i v\u1edbi gi\u00e1 c\u1ef1c s\u1ed1c.<\/p>\r\n<\/div>\r\n<p><a class=\"ctrl\" href=\"#content\" data-collapse=\"\">M\u00c3 GI\u1ea2M S\u1ed0C<\/a><\/p>\r\n<div id=\"other\">\r\n<p>M\u1ed7i ng\u00e0y v\u00e0o c\u00e1c khung gi\u1edd c\u1ed1 \u0111\u1ecbnh, m\u00e3 gi\u1ea3m s\u1ed1c s\u1ebd xu\u1ea5t hi\u1ec7n. Qu\u00fd kh\u00e1ch d\u00f9ng m\u00e3 gi\u1ea3m gi\u00e1 n\u00e0y \u0111\u1ec3 mua c\u00e1c s\u1ea3n ph\u1ea9m iPhone 8, iPhone X, Samsung Galaxy S9, Samsung Galaxy S9 Plus, Samsung Galaxy Note 8, Samsung Galaxy Note 9 v\u1edbi gi\u00e1 c\u1ef1c s\u1ed1c.<\/p>\r\n<\/div>\r\n<p><a class=\"ctrl\" href=\"#content\" data-collapse=\"\">QUY \u0110\u1ecaNH CHUNG V\u1ec0 M\u00c3 GI\u1ea2M GI\u00c1<\/a><\/p>\r\n<div id=\"other\">\r\n<p>- M\u1ed7i ng\u01b0\u1eddi (m\u1ed7i t\u00e0i kho\u1ea3n\/ m\u1ed7i s\u1ed1 \u0111i\u1ec7n tho\u1ea1i\/ m\u1ed7i \u0111\u1ecba ch\u1ec9 IP\/m\u1ed7i \u0111\u1ecba ch\u1ec9 nh\u1eadn h\u00e0ng) ch\u1ec9 \u0111\u01b0\u1ee3c s\u1eed d\u1ee5ng duy nh\u1ea5t 1 m\u00e3 gi\u1ea3m gi\u00e1 trong su\u1ed1t th\u1eddi gian di\u1ec5n ra s\u1ef1 ki\u1ec7n<\/p>\r\n<p>- Kh\u00f4ng \u0111\u01b0\u1ee3c thay \u0111\u1ed5i \u0111\u1ecba ch\u1ec9 nh\u1eadn h\u00e0ng sau khi \u0111\u1eb7t \u0111\u01a1n h\u00e0ng.<\/p>\r\n<p>- Nh\u1eb1m \u0111\u1ea3m b\u1ea3o quy\u1ec1n l\u1ee3i c\u1ee7a kh\u00e1ch h\u00e0ng, khi nh\u1eadn h\u00e0ng kh\u00e1ch h\u00e0ng c\u1ea7n cung c\u1ea5p CMND g\u1ed1c cho ph\u00e9p nh\u00e2n vi\u00ean giao h\u00e0ng ch\u1ee5p \u1ea3nh CMND \u0111\u1ec3 \u0111\u1ed1i chi\u1ebfu (t\u00ean ng\u01b0\u1eddi nh\u1eadn h\u00e0ng ph\u1ea3i tr\u00f9ng kh\u1edbp v\u1edbi CMND).<\/p>\r\n<p>- S\u1ed1 l\u01b0\u1ee3ng M\u00e3 gi\u1ea3m gi\u00e1 c\u00f3 h\u1ea1n v\u00e0 M\u00e3 gi\u1ea3m gi\u00e1 c\u00f3 th\u1ec3 \u0111\u01b0\u1ee3c s\u1eed d\u1ee5ng h\u1ebft tr\u01b0\u1edbc th\u1eddi h\u1ea1n n\u00e0y. V\u00ec v\u1eady nhanh tay s\u1eed d\u1ee5ng M\u00e3 gi\u1ea3m gi\u00e1 ngay khi c\u00f3 \u0111\u01b0\u1ee3c m\u00e3 \u0111\u1ec3 \u0111\u1ea3m b\u1ea3o mua \u0111\u01b0\u1ee3c s\u1ea3n ph\u1ea9m v\u1edbi gi\u00e1 s\u1ed1c nh\u00e9!<\/p>\r\n<\/div>\r\n<p><a class=\"ctrl\" href=\"#other\" data-collapse=\"\">QUY \u0110\u1ecaNH KH\u00c1C<\/a><\/p>\r\n<div id=\"other\">\r\n<p><img style=\"width: 100%;\" src=\"https:\/\/media3.scdn.vn\/img2\/2018\/10_15\/sX0Q85.png\" \/><\/p>\r\n<p>- <strong>Sendo.vn<\/strong> c\u00f3 quy\u1ec1n t\u1eeb ch\u1ed1i ph\u1ee5c v\u1ee5 c\u00e1c \u0111\u01a1n h\u00e0ng ch\u01b0a tu\u00e2n theo \u0111\u00fang th\u1ec3 l\u1ec7 ch\u01b0\u01a1ng tr\u00ecnh <strong>Deal s\u1ed1c \u0111i\u1ec7n tho\u1ea1i<\/strong> ho\u1eb7c \u0111\u01a1n h\u00e0ng c\u00f3 d\u1ea5u hi\u1ec7u gian l\u1eadn M\u00e3 gi\u1ea3m gi\u00e1.<\/p>\r\n<p>- Trong tr\u01b0\u1eddng h\u1ee3p x\u1ea3y ra tranh ch\u1ea5p li\u00ean quan \u0111\u1ebfn M\u00e3 gi\u1ea3m gi\u00e1, quy\u1ebft \u0111\u1ecbnh c\u1ee7a Sendo.vn s\u1ebd l\u00e0 quy\u1ebft \u0111\u1ecbnh cu\u1ed1i c\u00f9ng.<\/p>\r\n<p>- Trong m\u1ed9t s\u1ed1 t\u00ecnh hu\u1ed1ng b\u1ea5t kh\u1ea3 kh\u00e1ng, n\u1ed9i dung ch\u01b0\u01a1ng tr\u00ecnh c\u00f3 quy\u1ec1n thay \u0111\u1ed5i m\u00e0 kh\u00f4ng c\u1ea7n b\u00e1o tr\u01b0\u1edbc.<\/p>\r\n<p>- Nh\u00e2n vi\u00ean C\u00f4ng ty C\u1ed5 ph\u1ea7n C\u00f4ng ngh\u1ec7 <strong>Sen \u0110\u1ecf<\/strong> kh\u00f4ng \u0111\u01b0\u1ee3c tham gia ch\u01b0\u01a1ng tr\u00ecnh n\u00e0y.<\/p>\r\n<p>- Nh\u00e2n vi\u00ean c\u1ee7a c\u00e1c shop h\u1ee3p t\u00e1c v\u1edbi <strong>Sen \u0110\u1ecf<\/strong> cho ch\u01b0\u01a1ng tr\u00ecnh <strong>Deal s\u1ed1c \u0111i\u1ec7n tho\u1ea1i<\/strong> kh\u00f4ng \u0111\u01b0\u1ee3c tham gia ch\u01b0\u01a1ng tr\u00ecnh n\u00e0y.<\/p>\r\n<p>- Sen \u0110\u1ecf c\u00f3 quy\u1ec1n s\u1eed d\u1ee5ng h\u00ecnh \u1ea3nh c\u1ee7a kh\u00e1ch h\u00e0ng tham gia ch\u01b0\u01a1ng tr\u00ecnh \u0111\u1ec3 ph\u1ee5c v\u1ee5 c\u00f4ng t\u00e1c truy\u1ec1n th\u00f4ng.<\/p>\r\n<\/div>\r\n<p><a class=\"ctrl\" href=\"#content\" data-collapse=\"\">QUY \u0110\u1ecaNH CHUNG V\u1ec0 M\u00c3 GI\u1ea2M GI\u00c1<\/a><\/p>\r\n<div id=\"other\">\r\n<p>- M\u1ed7i ng\u01b0\u1eddi (m\u1ed7i t\u00e0i kho\u1ea3n\/ m\u1ed7i s\u1ed1 \u0111i\u1ec7n tho\u1ea1i\/ m\u1ed7i \u0111\u1ecba ch\u1ec9 IP\/m\u1ed7i \u0111\u1ecba ch\u1ec9 nh\u1eadn h\u00e0ng) ch\u1ec9 \u0111\u01b0\u1ee3c s\u1eed d\u1ee5ng duy nh\u1ea5t 1 m\u00e3 gi\u1ea3m gi\u00e1 trong su\u1ed1t th\u1eddi gian di\u1ec5n ra s\u1ef1 ki\u1ec7n<\/p>\r\n<p>- Kh\u00f4ng \u0111\u01b0\u1ee3c thay \u0111\u1ed5i \u0111\u1ecba ch\u1ec9 nh\u1eadn h\u00e0ng sau khi \u0111\u1eb7t \u0111\u01a1n h\u00e0ng.<\/p>\r\n<p>- Nh\u1eb1m \u0111\u1ea3m b\u1ea3o quy\u1ec1n l\u1ee3i c\u1ee7a kh\u00e1ch h\u00e0ng, khi nh\u1eadn h\u00e0ng kh\u00e1ch h\u00e0ng c\u1ea7n cung c\u1ea5p CMND g\u1ed1c cho ph\u00e9p nh\u00e2n vi\u00ean giao h\u00e0ng ch\u1ee5p \u1ea3nh CMND \u0111\u1ec3 \u0111\u1ed1i chi\u1ebfu (t\u00ean ng\u01b0\u1eddi nh\u1eadn h\u00e0ng ph\u1ea3i tr\u00f9ng kh\u1edbp v\u1edbi CMND).<\/p>\r\n<p>- S\u1ed1 l\u01b0\u1ee3ng M\u00e3 gi\u1ea3m gi\u00e1 c\u00f3 h\u1ea1n v\u00e0 M\u00e3 gi\u1ea3m gi\u00e1 c\u00f3 th\u1ec3 \u0111\u01b0\u1ee3c s\u1eed d\u1ee5ng h\u1ebft tr\u01b0\u1edbc th\u1eddi h\u1ea1n n\u00e0y. V\u00ec v\u1eady nhanh tay s\u1eed d\u1ee5ng M\u00e3 gi\u1ea3m gi\u00e1 ngay khi c\u00f3 \u0111\u01b0\u1ee3c m\u00e3 \u0111\u1ec3 \u0111\u1ea3m b\u1ea3o mua \u0111\u01b0\u1ee3c s\u1ea3n ph\u1ea9m v\u1edbi gi\u00e1 s\u1ed1c nh\u00e9!<\/p>\r\n<\/div>
                """;
                flutterWebviewPlugin.launch(selectedUrl,
                    html: html,
                    rect: new Rect.fromLTWH(
                        0.0, 0.0, MediaQuery.of(context).size.width, 400.0),
                    userAgent: kAndroidUserAgent,
                    withZoom: true);
              },
              child: const Text('Open Webview (rect) with Html'),
            ),
            new Container(
              padding: const EdgeInsets.all(24.0),
              child: new TextField(controller: _codeCtrl),
            ),
            new RaisedButton(
              onPressed: () {
                final future =
                    flutterWebviewPlugin.evalJavascript(_codeCtrl.text);
                future.then((String result) {
                  setState(() {
                    _history.add('eval: $result');
                  });
                });
              },
              child: const Text('Eval some javascript'),
            ),
            new RaisedButton(
              onPressed: () {
                setState(() {
                  _history.clear();
                });
                flutterWebviewPlugin.close();
              },
              child: const Text('Close'),
            ),
            new RaisedButton(
              onPressed: () {
                flutterWebviewPlugin.getCookies().then((m) {
                  setState(() {
                    _history.add('cookies: $m');
                  });
                });
              },
              child: const Text('Cookies'),
            ),
            new Text(_history.join('\n'))
          ],
        ),
      ),
    );
  }
}
