import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// This wrapper class using for simple cache data
///
class AppDataRepository {

  static final AppDataRepository _mInstance = new AppDataRepository._internal();

  AppDataRepository._internal();

  factory AppDataRepository () {
    return _mInstance;
  }

  static AppDataRepository get instances => _mInstance;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static _parseJson(String json) {
    JsonDecoder decoder = new JsonDecoder();
    return decoder.convert(json);
  }

  static String _encodeJson(Map<String, dynamic> map) {
    JsonEncoder encoder = new JsonEncoder();
    String s = encoder.convert(map);
    return s;
  }

  static List<Map<String, dynamic>> _parseJsonList(List<String> json) {
    JsonDecoder decoder = new JsonDecoder();
    final parsedList = List<Map<String, dynamic>>();
    for (var value in json) {
      parsedList.add(decoder.convert(value));
    }
    return parsedList;
  }

  static List<String> _encodeJsonList(List<Map<String, dynamic>> list) {
    final listJson = List<String>();
    final encoder = new JsonEncoder();
    for (var value in list) {
      listJson.add(encoder.convert(value));
    }
    return listJson;
  }

  Future<dynamic> setStringCache(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(key, value);
  }

  Future<dynamic> setIntCache(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setInt(key, value);
  }

  Future<dynamic> setBoolCache(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setBool(key, value);
  }

  Future<dynamic> setDoubleCache(String key, double value) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setDouble(key, value);
  }

  Future<dynamic> setStringListCache(String key, List<String> value) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setStringList(key, value);
  }

  @override
  Future<dynamic> getCache(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.get(key);
  }

  Future<dynamic> clear() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }

  Future<bool> remove(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove(key);
  }

  Future<bool> setListCache(String key, List<Map<String, dynamic>> list) async {
    final SharedPreferences prefs = await _prefs;
    final listJson = await compute(_encodeJsonList, list);
    return await prefs.setStringList(key, listJson);
  }

  Future<bool> setMapCache(String key, Map<String, dynamic> map) async {
    final SharedPreferences prefs = await _prefs;
    final json = await compute(_encodeJson, map);
    return await prefs.setString(key, json);
  }

  Future<List<Map<String, dynamic>>> getListCache(String key) async {
    final SharedPreferences prefs = await _prefs;
    List<String> cachedList = prefs.getStringList(key);

    if (cachedList == null || cachedList.isEmpty){
      return [];
    }

    return await compute(_parseJsonList, cachedList);
  }

  Future<Map<String, dynamic>> getMapCache(String key) async {
    final SharedPreferences prefs = await _prefs;
    final String cached = prefs.getString(key);

    if (cached == null) {
      return null;
    }

    return await compute(_parseJson, cached) as Map<String, dynamic>;
  }

}