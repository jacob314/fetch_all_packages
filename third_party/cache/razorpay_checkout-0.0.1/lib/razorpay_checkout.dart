import 'dart:async';

import 'package:flutter/services.dart';

class RazorpayCheckout {
  static const MethodChannel _channel =
      const MethodChannel('razorpay_checkout');

  static Future<String> show() async {
    String ver = await _channel.invokeMethod('showCheckout', <String, dynamic> {
      'amount': 2500,
      'email': 'rohan@thack.in',
      'phone': '0000000000',
    });
    return ver;
  }
}
