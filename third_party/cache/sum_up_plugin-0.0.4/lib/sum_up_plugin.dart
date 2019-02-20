import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sum_up_plugin/authentification_page.dart';
import 'package:sum_up_plugin/share_pref.dart';
import 'package:sum_up_plugin/token.dart';


class SumUpPlugin {
  static const MethodChannel _channel = const MethodChannel('sum_up_plugin');
  static const String redirectUrl = "http://localhost:8080";
  final String clientId;
  final String clientSecret;
  String authorizeUrl;

  SumUpPlugin({this.clientId, this.clientSecret}) {
    authorizeUrl =
    "https://api.sumup.com/authorize?response_type=code&client_id=${this
        .clientId}&redirect_uri=${SumUpPlugin.redirectUrl}";
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> login(BuildContext context) async {
    var token = await SharedPreferencesTest().getToken();

    if (token == null) {
      String authorizationCode = await auth(context);
      try {
        token = await Token.getToken(
            authorizationCode: authorizationCode,
            clientId: this.clientId,
            clientSecret: this.clientSecret);
      } catch (e) {
        throw e;
      }
    }

    try {
      String displayString = await _channel.invokeMethod(
          'login', {"token": token.access});
      return displayString;
    } catch (e) {
      try {
        Token _refreshedToken = await Token.getTokenFromRefreshToken(
            token: token,
            clientId: this.clientId,
            clientSecret: this.clientSecret);

        String displayString = await _channel
            .invokeMethod('login', {"token": _refreshedToken.access});
        return displayString;
      } catch (e) {
        throw e;
      }
    }
  }

  static Future<dynamic> prepareTransaction(String totalPrice) async {
    var request = await _channel
        .invokeMethod('prepareTransaction', {"totalPrice": totalPrice});

    print(request);
    return request;
  }

  static Future<String> paymentPreferences() async {
    String result = await _channel.invokeMethod('paymentPreferences');
    print(result);
    return result;
  }

  Future<String> auth(BuildContext context) async {
    String authorizationCode = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                AuthPage(
                  authUrl: this.authorizeUrl,
                  clientId: this.clientId,
                  clientSecret: this.clientSecret,
                )));

    return authorizationCode;
  }

  static Future<bool> isSumUpTokenValid() async {
    var request = await _channel
        .invokeMethod('isSumUpTokenValid');
    return request;
  }

}
