import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:darequest/request.dart';

import 'paginator.dart';

class LengthAwarePaginator extends Paginator {
  String url;

  int total = 0;
  int perPage = 15;
  int lastPage = 0;
  String nextPageUrl;
  String prevPageUrl;
  int from = 0;
  int to = 0;
  List<Map<String, Object>> data = [];

  LengthAwarePaginator({this.url});

  bool get hasNextPage => this.nextPageUrl != null;

  @override
  Future<List<Map<String, Object>>> onLoad(Response<HttpClientResponse> response) async {
    var responseBody;
    if (Request.parseResponse) {
      responseBody = response.responseBody;
    } else {
      var body = await response.response.transform(UTF8.decoder).join();
      responseBody = Request.decodeJson(body);
    }
    total = responseBody['total'];
    perPage = responseBody['per_page'];
    currentPage = responseBody['current_page'];
    lastPage = responseBody['last_page'];
    nextPageUrl = responseBody['next_page_url'];
    prevPageUrl = responseBody['prev_page_url'];
    from = responseBody['from'];
    to = responseBody['to'];
    data = responseBody['data'];
    return data;
  }

  @override
  String getUrl() {
    return this.url;
  }

  Map<String, Object> toMap() {
    Map<String, Object> map = new Map<String, Object>();
    map['total'] = total;
    map['per_page'] = perPage;
    map['current_page'] = currentPage;
    map['last_page'] = lastPage;
    map['next_page_url'] = nextPageUrl;
    map['prev_page_url'] = prevPageUrl;
    map['from'] = from;
    map['to'] = to;
    map['data'] = data;
    return map;
  }

}
