import 'dart:convert';
import 'dart:async';

import 'parse.dart';

import 'parse_base_object.dart';
import 'parse_http_client.dart';

class User implements ParseBaseObject {
  final String className = '_User';
  final ParseHTTPClient client;
  String path;
  Map<String, dynamic> objectData = {};

  String get objectId => objectData['objectId'];
  String get sessionId => objectData['sessionToken'];
  String get username => objectData['username'];
  String get userId => objectData['objectId'];
  
  User(): path = "/parse/classes/_User", client = Parse.getInstance().client;

  void set(String attribute, dynamic value){
    objectData[attribute] = value;
  }

  Future<dynamic> get(attribute) async {
    final response = this.client.client().get(client.parseInstance.serverUrl + "${path}/${objectId}");

    return response.then((value){
      objectData = JsonDecoder().convert(value.data);
      return objectData[attribute];
    });
  }

  Future<dynamic> me(attribute) async {
    final response = this.client.client().get(client.parseInstance.serverUrl + "${path}/me");
    client.addSessionHeader(sessionId);

    return response.then((value){
      objectData = JsonDecoder().convert(value.data);
      return objectData[attribute];
    });
  }

  Map<String, dynamic> _handleResponse(String response){
    Map<String, dynamic> responseData = JsonDecoder().convert(response);
    if (responseData.containsKey('objectId')) {
      objectData = responseData;
      this.client.addSessionHeader(sessionId);
    }
    return responseData;
  }

  void _resetObjectId(){
    if (objectId != null)
      objectData.remove('objectId');
    if (sessionId != null)
      objectData.remove('sessionToken');
  }

  Future<Map<String, dynamic>> signUp([Map<String, dynamic> objectInitialData]) async {
    if(objectInitialData != null) {
      objectData = {}..addAll(objectData)..addAll(objectInitialData);
    }
    _resetObjectId();
    print(objectData);
    final response = this.client.client().post("${client.parseInstance.serverUrl}${path}", data: JsonEncoder().convert(objectData));
    client.addUserRequestHeader();
    return response.then((value){
      _handleResponse(value.data);
      return objectData;
    });
  }

  Future<Map<String, dynamic>> login() async {
    Uri url = new Uri(
        path: "${client.parseInstance.serverUrl}/parse/login",
        queryParameters: {
          "username": objectData['username'],
          "password": objectData['password']
        });

    final response = this.client.client().post(url.toString());
    this.client.addUserRequestHeader();
    return response.then((value){
      _handleResponse(value.data);
      return objectData;
    });
  }

  Future<Map<String, dynamic>> verificationEmailRequest() async {
    final response = this.client.client().post(
        "${client.parseInstance.serverUrl}/parse/verificationEmailRequest",
        data: JsonEncoder().convert({"email": objectData['email']})
    );
    return response.then((value){
      return _handleResponse(value.data);
    });
  }

  Future<Map<String, dynamic>> requestPasswordReset() async {
    final response = this.client.client().post(
        "${client.parseInstance.serverUrl}/parse/requestPasswordReset",
        data: JsonEncoder().convert({"email": objectData['email']})
    );
    return response.then((value){
      return _handleResponse(value.data);
    });
  }

  Future<Map<String, dynamic>> save([Map<String, dynamic> objectInitialData]){
    objectData = {}..addAll(objectData)..addAll(objectInitialData);
    if (objectId == null){
      return signUp(objectData);
    }
    else {
      final response = this.client.client().put(
          client.parseInstance.serverUrl + "${path}/${objectId}",  data: JsonEncoder().convert(objectData));
      return response.then((value) {
        return _handleResponse(value.data);
      });
    }
  }

  Future<String> destroy(){
    final response = this.client.client().delete(client.parseInstance.serverUrl + "${path}/${objectId}");
    this.client.addUserRequestHeader();
    return response.then((value){
      _handleResponse(value.data);
      return objectId;
    });
  }

  Future<Map<String, dynamic>> all(){
      final response = this.client.client().get(
          client.parseInstance.serverUrl + "${path}"
      );
      return response.then((value) {
        return _handleResponse(value.data);
      });
  }

  @override
  ParseHTTPClient parseClient;

}

