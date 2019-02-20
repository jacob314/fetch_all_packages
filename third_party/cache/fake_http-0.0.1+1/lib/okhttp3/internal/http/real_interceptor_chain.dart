import 'dart:async';
import 'dart:io';

import 'package:fake_http/okhttp3/call.dart';
import 'package:fake_http/okhttp3/interceptor.dart';
import 'package:fake_http/okhttp3/request.dart';
import 'package:fake_http/okhttp3/response.dart';

class RealInterceptorChain implements Chain {
  final List<Interceptor> _interceptors;
  final HttpClient _httpClient;
  final int _index;
  final Request _request;
  final Call _call;

  RealInterceptorChain(List<Interceptor> interceptors, HttpClient httpClient,
      int index, Request request, Call call)
      : _interceptors = interceptors,
        _httpClient = httpClient,
        _index = index,
        _request = request,
        _call = call;

  HttpClient httpClient() {
    return _httpClient;
  }

  @override
  Request request() {
    return _request;
  }

  @override
  Call call() {
    return _call;
  }

  @override
  Future<Response> proceed(Request request) {
    return proceedRequest(request, _httpClient);
  }

  Future<Response> proceedRequest(Request request, HttpClient httpClient) {
    if (_index >= _interceptors.length) {
      throw new AssertionError();
    }
    RealInterceptorChain next = new RealInterceptorChain(
        _interceptors, httpClient, _index + 1, request, _call);
    Interceptor interceptor = _interceptors[_index];
    return interceptor.intercept(next);
  }
}