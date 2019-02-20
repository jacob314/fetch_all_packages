import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sum_up_plugin/token.dart';

class SharedPreferencesTest {
  final String _kToken = "SumUpToken";

  Future<Token> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenString = prefs.getString(_kToken);
    return tokenString != null ? Token.fromMap(json.decode(tokenString)) : null;
  }

  Future<bool> setToken(Token value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kToken, json.encode(value.toMap()));
  }

  Future<bool> resetToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kToken, null);
  }
}
