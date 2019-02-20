import 'package:flutter/material.dart';
import 'package:virgil/virgil.dart';

void main() => runApp(_App());

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.dark(),
        title: 'Virgil Example',
        home: Inferno(
          {
            '/': (context, arguments) => PageOne(),
            '/hello': (context, arguments) => PageTwo(arguments),
          },
        ).home(context),
      );
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('/'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: const Text('pushNamed'),
              color: Colors.lightBlue,
              onPressed: () async {
                await Virgil.of(context).pushNamed<dynamic, String>('/hello',
                    arguments: 'pushNamed');
              },
            ),
            MaterialButton(
              child: const Text('pushReplacementNamed'),
              color: Colors.lightGreen,
              onPressed: () async {
                await Virgil.of(context).pushReplacementNamed('/hello',
                    arguments: 'pushReplacementNamed');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo(this.arg);

  final String arg;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Scaffold(
          appBar: AppBar(
            title: const Text('/hello'),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('You passed: $arg'),
                MaterialButton(
                  child: arg == 'pushReplacementNamed'
                      ? const Text('Re-open the home page')
                      : const Text('Close this page'),
                  color: arg == 'pushReplacementNamed'
                      ? Colors.lightGreen
                      : Colors.lightBlue,
                  onPressed: () {
                    if (arg == 'pushReplacementNamed') {
                      Virgil.of(context).pushReplacementNamed('/');
                      return;
                    }
                    Navigator.of(context).pop('You returned data!');
                  },
                )
              ],
            ),
          ),
        ),
      );
}
