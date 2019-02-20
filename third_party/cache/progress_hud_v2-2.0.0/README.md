# progress_hud_v2

Homepage:
https://github.com/pablo384/progress_hud

A clean and lightweight progress HUD for your Flutter app based on the original progress_hud:
https://pub.dartlang.org/packages/progress_hud

## Example
```dart
class _MyHomePageState extends State<MyHomePage> {
  ProgressHUD _progressHUD;

  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Loading...',
    );
  }

  @override
  Widget build(BuildContext context) {
    void dismissProgressHUD() {
      setState(() {
        if (_loading) {
          _progressHUD.state.dismiss();
        } else {
          _progressHUD.state.show();
        }

        _loading = !_loading;
      });
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('ProgressHUD Demo'),
        ),
        body: new Stack(
          children: <Widget>[
            new Text(
                'A clean and lightweight progress HUD for your Flutter app'),
            _progressHUD,
            new Positioned(
                child: new FlatButton(
                    onPressed: dismissProgressHUD,
                    child: new Text(_loading ? "Dismiss" : "Show")),
                bottom: 30.0,
                right: 10.0)
          ],
        ));
  }
}
```

## Showcase

![](https://media.giphy.com/media/ir9XMNj8dIKcflkp21/giphy.gif)
