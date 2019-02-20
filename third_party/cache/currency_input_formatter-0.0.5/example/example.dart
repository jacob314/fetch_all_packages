import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_input_formatter/currency_input_formatter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Currency Formatter",
        home: new Scaffold(
            appBar: new AppBar(title: new Text("Currency Formatter")),
            body: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Salary",
                          prefixText: '\$',
                      ),
                      inputFormatters: <TextInputFormatter>[
                        new CurrencyInputFormatter(
                            allowSubdivisions: true,
                            subdivisionMarker: "."
                        ),
                      ],
                  ),
                ],
            ),
        ),
    );
  }
}