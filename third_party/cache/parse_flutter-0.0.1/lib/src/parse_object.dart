import 'dart:convert';
import 'dart:async';

import 'parse.dart';
import 'parse_http_client.dart';

import 'parse_base_object.dart';

class ParseObject implements ParseBaseObject {
  
  @override
  ParseHTTPClient parseClient;
  final String className;
  String path;
  Map<String, dynamic> objectData = {};
  String get objectId => objectData['objectId'];
  
  ParseObject(this.className) {
    path = "/parse/classes/$className";
    parseClient = Parse.getInstance().client;
  }

  Future<Map> create([Map<String, dynamic> objectInitialData]) async {
    objectData = {}..addAll(objectData)..addAll(objectInitialData);

    final response = this.parseClient.client().post("${parseClient.parseInstance.serverUrl}${path}", data: JsonEncoder().convert(objectData));
    return response.then((value){
      objectData = JsonDecoder().convert(value.data);
      return objectData;
    });
  }

  Future<dynamic> get(attribute) async {
      final response = this.parseClient.client().get(parseClient.parseInstance.serverUrl + "${path}/${objectId}");
      print(response.toString());
      return response.then((value){
        objectData = JsonDecoder().convert(value.data);
        return objectData[attribute];
      });
  }

  void set(String attribute, dynamic value){
    objectData[attribute] = value;
  }

  Future<Map> save([Map<String, dynamic> objectInitialData]){
    objectData = {}..addAll(objectData)..addAll(objectInitialData);
    if (objectId == null){
        return create(objectData);
    }
    else {
      final response = this.parseClient.client().put(
          parseClient.parseInstance.serverUrl + "${path}/${objectId}",  data: JsonEncoder().convert(objectData));
      return response.then((value) {
        objectData = JsonDecoder().convert(value.data);
        return objectData;
      });
    }
  }

  Future<String> destroy(){
    final response = this.parseClient.client().delete(parseClient.parseInstance.serverUrl + "${path}/${objectId}");
    return response.then((value){
      return JsonDecoder().convert(value.data);
    });
  }
}

