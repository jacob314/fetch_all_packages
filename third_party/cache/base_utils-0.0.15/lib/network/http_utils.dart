import 'dart:async';
import 'dart:convert';

import 'package:base_utils/utils/logging_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

enum Method { GET, POST }

const DEFAULT_TIMEOUT_SEC = 30;

class DataRequest<T> {
  Function(T data) onSuccess;
  Function(dynamic error) onFailure;

  DataRequest({this.onSuccess, this.onFailure});
}

class Request {
  final Method method;
  final String host;
  final String path;
  final Map<String, dynamic> params;
  final Map<String, dynamic> headers;
  Function(String data) onSuccess;
  Function(dynamic error) onFailure;

  Request(
      {Key key,
      @required this.method,
      @required this.host,
      @required this.path,
      this.params,
      this.headers,
      this.onSuccess,
      this.onFailure});

  @override
  String toString() {
    return "method: $method, host: $host, path: $path, headers: $headers, params: $params";
  }
}

Future<dynamic> request(Request request,
    [Duration timeout = const Duration(seconds: DEFAULT_TIMEOUT_SEC)]) async {
  log("--> REQUEST: ${request.toString()}");

  final _contentType =
      request.headers != null ? request.headers["Content-Type"] : null;
  var _body,
      _uri,
      _headers = request.headers != null
          ? Map<String, String>.from(request.headers)
          : null;

  var _onError = (e) {
    log("<-- ERROR: $e");
    request.onFailure(e);
  };

  switch (_contentType) {
    case "application/json":
      _body = json.encode(request.params);
      log("--> REQUEST_BODY: $_body");

      switch (request.method) {
        case Method.POST:
          _uri = Uri.parse(request.host).replace(path: request.path);
          log("--> REQUEST_URL: $_uri");

          return post(
            _uri,
            headers: _headers,
            body: _body,
            encoding: utf8,
          ).timeout(timeout).then(
            (response) {
              //get header
              var _serverHeaders = response.headers;
              log("<-- RESPONSE HEADERS: $_serverHeaders");
              //get body data
              String _jsonStr = response.body;
              log("<-- RESPONSE: $_jsonStr");
              request.onSuccess(_jsonStr);
            },
            onError: _onError,
          );
        case Method.GET:
          var _uri = Uri.parse(request.host)
              .replace(path: request.path, queryParameters: request.params);
          log("--> REQUEST_URL: $_uri");
          return get(_uri, headers: _headers).timeout(timeout).then(
            (response) {
              //get header
              var _serverHeaders = response.headers;
              log("<-- RESPONSE HEADERS: $_serverHeaders");
              //get body data
              String _jsonStr = response.body;
              log("<-- RESPONSE: $_jsonStr");
              request.onSuccess(_jsonStr);
            },
            onError: _onError,
          );

        default:
          _onError('Not supported method!');
          return null;
      }

      break;
    case "application/x-www-form-urlencoded":
    default:
      Map<String, String> _params = {};
      if (request.params != null) {
        request.params.forEach((k, v) {
          _params[k] = v.toString();
        });
      }

      switch (request.method) {
        case Method.POST:
          _uri = Uri.parse(request.host).replace(path: request.path);
          log("--> REQUEST_URL: $_uri");

          return post(
            _uri,
            headers: _headers,
            body: _params,
            encoding: utf8,
          ).timeout(timeout).then(
            (response) {
              //get header
              var _serverHeaders = response.headers;
              log("<-- RESPONSE HEADERS: $_serverHeaders");
              //get body data
              String _jsonStr = response.body;
              log("<-- RESPONSE: $_jsonStr");
              request.onSuccess(_jsonStr);
            },
            onError: _onError,
          );
        case Method.GET:
          var _uri = Uri.parse(request.host)
              .replace(path: request.path, queryParameters: _params);
          log("--> REQUEST_URL: $_uri");
          return get(_uri, headers: _headers).timeout(timeout).then(
            (response) {
              //get header
              var _serverHeaders = response.headers;
              log("<-- RESPONSE HEADERS: $_serverHeaders");
              //get body data
              String _jsonStr = response.body;
              log("<-- RESPONSE: $_jsonStr");
              request.onSuccess(_jsonStr);
            },
            onError: _onError,
          );

        default:
          _onError('Not supported method!');
          return null;
      }
      break;
  }
}
