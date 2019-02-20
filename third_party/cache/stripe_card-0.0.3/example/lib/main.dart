import 'package:flutter/material.dart';
import 'package:stripe_card/stripe_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = "";
  StripeController controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
              child: Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(top: 100.0),
                      width: 300,
                      height: 60,
                      child: StripeCard(
                        onStripeWidgetCreated: _onStripeWidgetCreated,
                        info: <String, dynamic>{
                          'left': 40,
                          'top': 300,
                          'right': 40,
                          'bottom': 0,
                          "publishKey" : "pk_test"
                        }
                      )
                  ),

                  Text(
                    _token != null ? _token : '',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 60.0
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: _onCreateToken,
                    tooltip: 'CreateToken',
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            )
        )
    );
  }

  void _onCreateToken() {
    if (controller != null) {
      controller.validation().then((bool result){
        if (result) {
          controller.createToken().then((String value){
            setState(() {
              _token = value;
            });
          });
        } else {
          setState(() {
            _token = "Invalid card info";
          });
        }
      });
    }
  }

  void _onStripeWidgetCreated(StripeController _controller) {
    controller = _controller;
  }
}
