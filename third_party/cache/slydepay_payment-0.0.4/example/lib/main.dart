import 'package:flutter/material.dart';
import 'dart:async';
import 'package:slydepay_payment/slydepay_payment.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<Null> _startPayment() async {
    List<dynamic> result = await SlydepayPayment.openSlydepayPaymentDialog(
        amount: 1.0,
        itemName: "iphone",
        description: "no description",
        customerName: "Vijay",
        customerEmail: "vijay@awoshe.com",
        orderCode: "test",
        phoneNumber: "123456789",
        merchantKey: "1528712354922",
        merchantEmail: "vijay@awoshe.com");
    print("RESULT TYPE " + result[0]); // 1: SUCCESS, 2: FAILED, 3: CANCELLED
    print("MSG " + result[1]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Slydepay Plugin (Awoshe)'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: RaisedButton(
                color: Colors.blueAccent,
                child: new Text(
                  "Pay with SlydePay",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _startPayment,
              ),
            ),
            SizedBox(height: 30.0),
            Center(
              child: Text(
                "https://www.awoshe.com",
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
