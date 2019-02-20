import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class ParseConfiguration {
  static var _prefs = SharedPreferences.getInstance();
  static String _applicationId = "ApplicationID";
  static String _masterKey = "Master-Key";
  static String _serverUrl = "Server-Url";
  static String _liveQueryUrl = "LiveQuery-Url";
  static String _sessionId = "Session-Id";

  String applicationId = null;
  String masterKey = null;
  String serverUrl = null;
  String liveQueryUrl = null;
  String sessionId = null;

  ParseConfiguration(
      [this.applicationId,
      this.masterKey,
      this.serverUrl,
      this.liveQueryUrl,
      this.sessionId]) {}

  void save() {
    _setApplicationId(applicationId);
    _setMasterKey(masterKey);
    _setServerUrl(serverUrl);
    _setLiveQueryUrl(liveQueryUrl);
  }

  void _setApplicationId(String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_applicationId, value);
  }

  Future<String> getApplicationId() async =>
      _prefs.then((SharedPreferences prefs) {
        return (prefs.getString(_applicationId) ?? null);
      });

  void _setMasterKey(String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_masterKey, value);
  }

  Future<String> getMasterKey() async => _prefs.then((SharedPreferences prefs) {
        return (prefs.getString(_masterKey) ?? null);
      });

  void _setServerUrl(String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_serverUrl, value);
  }

  Future<String> getServerUrl() async => _prefs.then((SharedPreferences prefs) {
        return (prefs.getString(_serverUrl) ?? null);
      });

  void _setLiveQueryUrl(String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_liveQueryUrl, value);
  }

  Future<String> getLiveQueryUrl() async =>
      _prefs.then((SharedPreferences prefs) {
        return (prefs.getString(_liveQueryUrl) ?? null);
      });

  void setSessionId(String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(_sessionId, value);
  }

  Future<String> getSessionId() async => _prefs.then((SharedPreferences prefs) {
        return (prefs.getString(_sessionId) ?? null);
      });
}
