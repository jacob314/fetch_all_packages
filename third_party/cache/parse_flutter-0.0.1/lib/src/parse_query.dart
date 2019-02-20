import 'dart:async';

import 'parse.dart';

import 'parse_base_object.dart';
import 'parse_http_client.dart';

class Query implements ParseBaseObject {
  
  String className;
  ParseHTTPClient client;
  String path;
  Map results;
  Map constraint;

  String get objectId => null;
  Map<String, dynamic> objectData = {};
  Query(String className) : client = Parse.getInstance().client;

  void equalTo (String key, dynamic value ) {

  }

  void notEqualTo(String key, dynamic value) {

  }

  void limit(int limit) {

  }

  void skip(int limit) {

  }

  void ascending(String attribute) {

  }

  void descending(String attribute) {

  }

  void startsWith(String key, dynamic value) {

  }

  Future<Map> first() {
    Map<String, dynamic> t = {};
    foo() => t;
    return new Future(foo);
  }

  @override
  ParseHTTPClient get parseClient => client;

  @override
  set parseClient(ParseHTTPClient _parseClient) {}
}