import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futils/futils.dart';

typedef MessageChannelCallback = void Function(String message);

class FWebView {

  // set message channel callback
  static void setMessageChannelCallback(void callback(String message)) {
    Futils.messageChannel.setMessageHandler((message){
      if (callback != null) callback(message);
      return Future<String>((){});
    });
  }

  // use web view launch url
  static Future<String> launchUrlInWebView(String url) async {
    final String result = await Futils.methodChannel.invokeMethod('launchWebView',
        <String, dynamic>{
      'url': url,
    });
    return result;
  }

  // close web view
  static Future<String> closeWebView() async {
    final String result = await Futils.methodChannel.invokeMethod('closeWebView');
    return result;
  }

  // use widget launch url
  static Future<String> launchUrlInWidget(BuildContext context, String url,
      {MessageChannelCallback messageCallback,}) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return _WebView(url: url, messageChannelCallback: messageCallback,);
    },),);
  }
}

class _WebView extends StatefulWidget {
  _WebView({
    Key key,
    @required this.url,
    this.messageChannelCallback,
  }) : assert(url != null),
        super(key: key);

  @override
  _WebViewState createState() => _WebViewState();

  final String url;
  final MessageChannelCallback messageChannelCallback;
}

class _WebViewState extends State<_WebView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // set message channel callback
    FWebView.setMessageChannelCallback((message){
      if (widget.messageChannelCallback != null) {
        widget.messageChannelCallback(message);
      }
    });
    // launch url
    FWebView.launchUrlInWebView(widget.url);
  }

  @override
  void didUpdateWidget(_WebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // set message channel callback
    FWebView.setMessageChannelCallback((message){
      if (widget.messageChannelCallback != null) {
        widget.messageChannelCallback(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return WillPopScope(
      child: Container(color: theme.scaffoldBackgroundColor,),
      onWillPop: (){
        return Future<bool>((){
          FWebView.setMessageChannelCallback((message){});
          FWebView.closeWebView();
          return true;
        });
      },
    );
  }
}
