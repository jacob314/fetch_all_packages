import 'dart:async';
import 'dart:io';

import 'package:darequest/request.dart';

abstract class Paginator {

  int currentPage = 0;


  Future<List> load([Map<String, dynamic> params]) {
    return Request.get(getUrl(), {"params": params}).then((response) {
      return onLoad(response);
    });
  }

  Future<List> page(int page, [Map<String, dynamic> params]){
    if (params == null) {
      params = {};
    }
    params['page'] = page;
    return load(params);
  }

  Future<List> next([Map<String, dynamic> params]){
    if (params == null) {
      params = {};
    }
    params['page'] = currentPage + 1;
    return load(params);
  }

  Future<List> prev([Map<String, dynamic> params]){
    if (params == null) {
      params = {};
    }
    params['page'] = currentPage - 1;
    return load(params);
  }


  Future<List> onLoad(Response<HttpClientResponse> response);

  String getUrl();
}
