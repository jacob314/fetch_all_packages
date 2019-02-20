import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flipper/flipper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(backgroundColor: Colors.grey[900], body: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String _description =
      'Raskolnikov, an impoverished student living in the St. Petersburg of the tsars, is determined to overreach his humanity and assert his untrammeled individual will. When he commits an act of murder and theft, he sets into motion a story that, for its excruciating suspense, its atmospheric vividness, and its depth of characterization and vision is almost unequaled in the literatures of the world.';

  GlobalKey<FlipperState> _key = GlobalKey<FlipperState>();

  AnimationController _controller;
  Animation _blurAnimation;
  Animation _percentsAnimation;

  int _counter = 0;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    _blurAnimation = CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 0.4, curve: Curves.ease));
    _percentsAnimation = CurvedAnimation(
        parent: _controller, curve: Interval(0.7, 1.0, curve: Curves.ease));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flipper(
              key: _key,
              flipThreshold: 0.60,
              obverseChild: Stack(alignment: Alignment.center, children: [
                _Obverse(
                  animation: _blurAnimation,
                ),
                FadeTransition(
                  opacity: _percentsAnimation,
                  child: Text(
                    '$_counter%',
                    style: TextStyle(color: Colors.white, fontSize: 32.0),
                  ),
                ),
              ]),
              reverseChild: _Reverse(onDownloadTap: () {
                Future.delayed(Duration(milliseconds: 1500), () {
                  _key.currentState.flipCard(Direction.right);
                  Future.delayed(Duration(milliseconds: 350), () {
                    _controller.forward().orCancel;
                    _timer = Timer.periodic(Duration(milliseconds: 1500),
                        (t) => setState(() => _counter++));
                  });
                });
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Crime and Punishment',
                  style: TextStyle(color: Colors.white70, fontSize: 20.0)),
            ),
            Text('Fyodor Dostoyevsky', style: TextStyle(color: Colors.white30)),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _description,
                style: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'Merriweather',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Reverse extends StatefulWidget {
  const _Reverse({
    Key key,
    @required this.onDownloadTap,
  }) : super(key: key);

  final Function onDownloadTap;

  @override
  _ReverseState createState() {
    return new _ReverseState();
  }
}

class _ReverseState extends State<_Reverse> {
  List<List<String>> _praises = [
    [
      '"The novels of Dostoevsky are seething whirlpools, gyrating sandstorms, waterpouts which hiss and boil and suck us in."',
      'Virginia Woolf'
    ],
    [
      '"We have to read Crime and Punishment—though it is horrowing—because, like Shakespeare, it alters out consciousness."',
      'Harold Bloom'
    ],
    [
      '"Dostoevsky is the man more than any other who has created modern prose…"',
      'James Joyce'
    ],
  ];

  int _currentPraise = 0;
  bool _downloading = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        Duration(seconds: 5),
        (t) => setState(
            () => _currentPraise = ++_currentPraise % _praises.length));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/reverse.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.headset, color: Colors.white70, size: 20.0),
                Text(
                  ' 350K+',
                  style: TextStyle(color: Colors.white70),
                ),
                Container(
                  width: 24.0,
                ),
                Icon(Icons.favorite, color: Colors.white70, size: 20.0),
                Text(
                  ' 1M+',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            height: 16.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Column(
                  key: Key(_praises[_currentPraise][0]),
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _praises[_currentPraise][0],
                      style: TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        fontSize: 16.0,
                        fontFamily: 'Merriweather',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '— ${_praises[_currentPraise][1]}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w800,
                          fontSize: 20.0,
                          fontFamily: 'Merriweather',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.bookmark_border,
                color: Colors.white70,
              ),
              Material(
                type: MaterialType.transparency,
                child: InkResponse(
                  onTap: () => setState(() {
                        _downloading = true;
                        widget.onDownloadTap();
                      }),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      layoutBuilder: (current, oldList) {
                        return Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: _downloading
                              ? CircularProgressIndicator()
                              : Icon(
                                  Icons.file_download,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.favorite_border,
                color: Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Obverse extends AnimatedWidget {
  _Obverse({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  static final ColorTween _colorTween =
      ColorTween(begin: Colors.transparent, end: Colors.black);
  static final Tween _blurTween = Tween(begin: 0.0, end: 1.5);
  static final Tween _scaleTween = Tween(begin: 1.0, end: 1.3);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: ClipRect(
        child: Transform.scale(
          scale: _scaleTween.evaluate(listenable),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/portrait.jpg'),
              fit: BoxFit.cover,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: _blurTween.evaluate(listenable),
                  sigmaY: _blurTween.evaluate(listenable)),
              child: Container(
                decoration: BoxDecoration(
                  color: _colorTween.evaluate(listenable),
                  backgroundBlendMode: BlendMode.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
