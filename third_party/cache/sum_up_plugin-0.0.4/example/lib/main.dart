import 'package:flutter/material.dart';
import 'package:sum_up_plugin/sum_up_plugin.dart';

String _clientId = "";
String _clientSecret = "";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  SumUpPlugin sumUpPlugin = new SumUpPlugin(
      clientId: _clientId, clientSecret: _clientSecret);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(builder: (BuildContext context) =>
            Center(
                child: Column(children: [
                  RaisedButton(
                      child: Text("Login"),
                      onPressed: () {
                        this.sumUpPlugin.login(context)
                            .then((String s) => print(s))
                            .catchError((e) => print(e));
                      }),
                  RaisedButton(
                    child: Text("prepareTransaction"),
                    onPressed: () =>
                        SumUpPlugin.prepareTransaction(100.toString()),
                  ),
                  RaisedButton(
                    child: Text("islog"),
                    onPressed: () =>
                        SumUpPlugin.isSumUpTokenValid().then((value){print(value);}),
                  ),
                  RaisedButton(
                    child: Text("paymentPreference"),
                    onPressed: () => SumUpPlugin.paymentPreferences(),
                  )
                ]))),
      ),
    );
  }
}
