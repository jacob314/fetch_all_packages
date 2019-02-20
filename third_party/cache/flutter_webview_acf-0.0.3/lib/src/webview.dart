import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'base.dart';

class WebView extends StatefulWidget {
  final String src;
  final double top;
  final bool loadData;
  final bool withJavascript;
  final bool clearCache;
  final bool clearCookies;
  final bool enableAppScheme;
  final String userAgent;
  final bool primary;
  final bool withZoom;
  final bool withLocalStorage;
  final bool withLocalUrl;
  final bool scrollBar;

  final Map<String, String> headers;

  const WebView(
      {Key key,
      @required this.src,
      @required this.top,
      @required this.loadData,
      this.headers,
      this.withJavascript,
      this.clearCache,
      this.clearCookies,
      this.enableAppScheme,
      this.userAgent,
      this.primary = true,
      this.withZoom,
      this.withLocalStorage,
      this.withLocalUrl,
      this.scrollBar})
      : super(key: key);

  @override
  _WebViewState createState() => new _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webviewReference = new FlutterWebviewPlugin();
  Rect _rect;
  Timer _resizeTimer;

  @override
  void initState() {
    super.initState();
    webviewReference.close();
  }

  @override
  void dispose() {
    super.dispose();
    webviewReference.close();
    webviewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_rect == null) {
      _rect = _buildRect(context);
      webviewReference.launch(widget.loadData,widget.src,
          headers: widget.headers,
          withJavascript: widget.withJavascript,
          clearCache: widget.clearCache,
          clearCookies: widget.clearCookies,
          enableAppScheme: widget.enableAppScheme,
          userAgent: widget.userAgent,
          rect: _rect,
          withZoom: widget.withZoom,
          withLocalStorage: widget.withLocalStorage,
          withLocalUrl: widget.withLocalUrl,
          scrollBar: widget.scrollBar);
    } else {
      final rect = _buildRect(context);
      if (_rect != rect) {
        _rect = rect;
        _resizeTimer?.cancel();
        _resizeTimer = new Timer(new Duration(milliseconds: 300), () {
          // avoid resizing to fast when build is called multiple time
          webviewReference.resize(_rect);
        });
      }
    }
    return new Container(
        child: const Center(child: const CircularProgressIndicator()));
  }

  Rect _buildRect(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = widget.primary ? mediaQuery.padding.top : 0.0;
    final top = topPadding;
    var height = mediaQuery.size.height - top;
    if (height < 0.0) {
      height = 0.0;
    }
    print("Top : ${widget.top}");
    return new Rect.fromLTWH(0.0, top + widget.top, mediaQuery.size.width, height - widget.top);
  }
}
