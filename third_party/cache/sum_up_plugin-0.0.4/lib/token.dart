import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sum_up_plugin/share_pref.dart';


class Token {
  final String access;
  final String refreshToken;
  final String type;
  final num expiresIn;
  DateTime expiresAt;
  DateTime refreshTokenExpiresAt;

  Token(this.access, this.type, this.expiresIn, this.refreshToken,
      this.expiresAt, this.refreshTokenExpiresAt);

  Token.fromMap(Map<String, dynamic> json)
      : access = json['access_token'],
        type = json['token_type'],
        expiresIn = json['expires_in'],
        refreshToken = json['refresh_token'];

  //expiresAt = new DateTime.now().add(new Duration(seconds: 3600)),
  //refreshTokenExpiresAt = new DateTime.now().add(new Duration(days: 6 * 29)); // 6 months

  Map<String, String> toMap() {
    return {
      'access_token': this.access,
      'refresh_token': this.refreshToken,
      'type': this.type,
      'expiresIn': this.expiresIn.toString(),
      //'expiresAt': this.expiresAt.toString(),
      //'refreshTokenExpiresAt': this.refreshTokenExpiresAt.toString(),
    };
  }

  static Future<Token> getToken(
      {String authorizationCode, String clientId, String clientSecret}) async {
    print("geting token");
    var body = {
      'grant_type': 'authorization_code',
      'client_id': '$clientId',
      'client_secret': '$clientSecret',
      'redirect_uri': 'http://localhost:8080',
      'code': '$authorizationCode'
    };
    final http.Response response = await http.post(
        "https://api.sumup.com/token",
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body);

    if (response.statusCode == 200) {
      Token token = Token.fromMap(json.decode(response.body));
      SharedPreferencesTest().setToken(token);
      return token;
    }
    else {
      throw Exception(response.body);
    }
  }

  static Future<Token> getTokenFromRefreshToken(
      {Token token, String clientId, String clientSecret}) async {
    var body = {
      'grant_type': 'refresh_token',
      'client_id': '$clientId',
      'client_secret': '$clientSecret',
      'refresh_token': '${token.refreshToken}'
    };

    final http.Response response = await http.post(
        "https://api.sumup.com/token",
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body);

    if (response.statusCode == 200) {
      Token _token = Token.fromMap(json.decode(response.body));
      SharedPreferencesTest().setToken(token);
      return _token;
    }
    else {
      throw Exception(response.body);
    }
  }
}
