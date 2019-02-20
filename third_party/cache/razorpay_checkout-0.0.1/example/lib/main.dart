import 'dart:async';
import 'package:flutter/material.dart';
import 'package:razorpay_checkout/razorpay_checkout.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _paymentStatus;

  @override
  void initState() {
    super.initState();
    setState(() {
      _paymentStatus = 'Idle';
    });
  }

  Future<void> showCheckout() async {
    String checkoutResult;
    try {
      checkoutResult = await RazorpayCheckout.show();
    } on Exception {
      checkoutResult = 'Failed to show Razorpay Checkout';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Razorpay Checkout example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Payment Status : $_paymentStatus'),
              FlatButton(
                onPressed: () => showCheckout(),
                child: Text('Open Checkout')
              ),
            ],
          )
        ),
      )
    );
  }
}
