# futils

Flutter Some Utils.
(SinPointsWidget、LoopBannerWidget、FWebViewWidget).

+ FWebView:
	+ FWebView.setMessageChannelCallback(void callback(String message));
		+ {"ShouldOverrideUrl","https://github.com"}
		+ {"PageStarted","https://github.com"}
		+ {"PageFinished","https://github.com"}
	+ FWebView.launchUrlInWebView(String url);
	+ FWebView.closeWebView();
	+ FWebView.launchUrlInWidget(BuildContext context, String url, {MessageChannelCallback messageCallback,});


## Getting Started

#### Usage

To use this plugin, add **futils** as a dependency in your *pubspec.yaml* file.

```
dependencies:
  futils: ^0.0.8
```

In your *.dart* file.

```
import 'package:futils/futils.dart';
import 'package:futils/sin_points.dart';
import 'package:futils/loop_banner.dart';
import 'package:futils/fwebview.dart';
```

#### Example - FWebView

```
// receiving message from message channel
FWebView.setMessageChannelCallback((message){
  print('Received message: $message');
  var msg = jsonDecode(message);
  if (msg != null) {
    String url = msg['ShouldOverrideUrl'];
    if (url != null && url.startsWith('fgit:')) {
      FWebView.closeWebView();
      Uri uri = Uri.parse(url);
      String code = uri.queryParameters['code'];
      print('Received github code: $code');
    }
  }
});
FWebView.launchUrlInWebView('https://github.com/login/oauth/authorize?client_id=980af8b605f82ea3f5cc');
FWebView.closeWebView();
```

#### Example - SinPoints

```
MaterialButton(
  onPressed: (){
    setState((){
      _running ^= true;
    });
  },
  child: SizedBox(
    width: 160,
    height: 160,
    child: SinPoints(
      running: _running,
    ),
  ),
)
```

#### Example - LoopBanner

```
Center(
  child: LoopBanner(
    duration: Duration(seconds: 3),
    itemCount: 6,
    itemBuilder: (context, position){
      return Card(
        color: position % 3 == 0 ? Color(0xff33b5e5) :
               position % 3 == 1 ? Color(0xffdd4400) :
                                   Color(0xff44cc00),
        child: MaterialButton(
          onPressed: (){},
          child: Center(
            child: Text('${position + 1}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
        ),
      );
    },
  ),
)
```


## Other

```
This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.io/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
```

