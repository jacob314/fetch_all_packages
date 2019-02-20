import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ulti_plugin/config.dart';

class DataRequest<T> {
  Function(T output) onSuccess;
  Function(dynamic output) onFailure;
}

class Request {
  //StartPoint and EndPoint, Param
  String urlEnpoint;

  Map<String, String> params = Map();

  Method method;

  Request({Key key, this.urlEnpoint, this.method = Method.GET});

  Function(String data) onSuccess;

  Function(dynamic data) onFailure;
}

enum Method { GET, POST }

class HttpUtility {
  static final String baseUrl = Config.domain;

  //Create Client
  final _httpRequest = HttpClient();

  void request(Request request) async {
    var url = Uri.https(baseUrl, request.urlEnpoint, request.params);

    String strMethod = 'GET';
    if (request.method == Method.GET) {
      strMethod = 'GET';
    } else {
      strMethod = 'POST';
    }

    _httpRequest.openUrl(strMethod, url).then((requestClient) {
      var response = requestClient.close();

      response.then((value) async {

        //get body data
        String strJSONDATA = await value.transform(utf8.decoder).join();

        request.onSuccess(strJSONDATA);
      }, onError: (e) {
        request.onFailure(e);
      });
    }, onError: (e) {
      request.onFailure(e);
    });

    print("==========================");
    print(url);
    print(request.params);
    print("==========================");
  }
}
