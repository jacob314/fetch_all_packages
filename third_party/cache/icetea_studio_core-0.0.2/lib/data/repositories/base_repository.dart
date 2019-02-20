import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:icetea_studio_core/data/base/base_result_entity.dart';
import 'package:icetea_studio_core/data/repositories/app_data_repository.dart';
import 'package:icetea_studio_core/data/utils/request_builder_util.dart';
import 'package:icetea_studio_core/domain/constants/global.dart';
import 'package:icetea_studio_core/domain/errors/fetch_data_exception.dart';
import 'package:icetea_studio_core/domain/errors/item_not_found_exception.dart';
import 'package:icetea_studio_core/domain/errors/missing_token_exception.dart';
import 'package:icetea_studio_core/domain/errors/network_timeout_exception.dart';
import 'package:icetea_studio_core/domain/errors/not_authorized_exception.dart';
import 'package:icetea_studio_core/domain/errors/token_invalid_exception.dart';
import 'package:icetea_studio_core/domain/errors/unauthenticated_exception.dart';
import 'package:icetea_studio_core/domain/errors/unknow_error_exception.dart';
import 'package:icetea_studio_core/domain/services/logger/logger_manager.dart';
import 'package:path/path.dart';

class BaseRepository {

  final _encoder = new JsonEncoder();

  LoggerManager logger;

  final _appDataRepository = new AppDataRepository();

  BaseRepository(this.logger);

  Future<BaseResultEntity> _processResponse(http.Response response) async {
    final String res = response.body;
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      throw new FetchDataException (
          "An error ocurred : [Status Code : $statusCode]",
          response.request.url.toString()
      );
    } else {
      final BaseResultEntity result = await compute(_parseResult, res);

      if (result == null) {
        throw new FetchDataException("An error while trying parse response", response.request.url.toString());
      }

      if (result.status == null) {
        throw new FetchDataException(
            "Invalid response: respone without statusCode",
            response.request.url.toString()
        );
      }

      switch (result.status) {
        case StatusCodes.SUCCESS:
          return result;
        case StatusCodes.UNKNOWN_ERROR:
          throw new UnknownErrorException(result.message);
        case StatusCodes.ITEM_NOT_FOUND:
          throw new ItemNotFoundException(result.message);
        case StatusCodes.AUTH_ERROR:
          throw new UnAuthenticatedException(result.message);
        case StatusCodes.MISSING_AUTH_TOKEN:
          throw new MissingTokenException(result.message);
        case StatusCodes.TOKEN_INVALID:
          throw new TokenInvalidException(result.message);
        case StatusCodes.NOT_AUTHORIZED:
          throw new NotAuthorizedException(result.message);
        default:
          throw new FetchDataException(
              "Unknow error code ${result.status}",
              response.request.url.toString()
          );
      }
    }
  }

  static BaseResultEntity _parseResult(String json) {
    try{
      final _decoder = new JsonDecoder();
      final parsedData = _decoder.convert(json) as Map<String, dynamic>;
      return BaseResultEntity.fromJson(parsedData);
    }catch(e) {
      print("BaseRequest error: _parseResult");
      print(e);
      return null;
    }
  }

  Future<Map<String, String>> _getHeaders([bool isMultipart = false]) async {
    Map<String, String> headers;

    if (isMultipart) {
      headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };
    } else {
      headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
    }

    String token;

    try {
      token = await _appDataRepository.getCache(CacheKeys.JWT);
    } catch (e) {
      print(e);
    }

    if (token != null) {
      headers['Authorization'] = 'Bearer ${token}';
    }

    return headers;
  }

  Future<http.Response> _onRequestTimeout() {
    throw new NetworkTimeoutException();
  }

  String _normalizeBody(Map<String, dynamic> body) => body != null ? _encoder.convert(body) : null;

  Future<dynamic> get(String url, [Map<String, dynamic> params]) async {
    if (params != null) {
      url = url + '?' + RequestBuilderUtil.buildGetUrl(params);
    }

    _log('HTTP.get', url);

    var headers = await _getHeaders();

    http.Response response = await http.get(Uri.encodeFull(url), headers: headers).timeout(HTTP_TIMEOUT, onTimeout: _onRequestTimeout);

    return _processResponse(response);
  }

  Future<dynamic> post(String url, [Map<String, dynamic> data]) async {
    var headers = await _getHeaders();
    _log('HTTP.post', url);
    http.Response response = await http.post(Uri.encodeFull(url), body: _normalizeBody(data), headers: headers).timeout(HTTP_TIMEOUT, onTimeout: _onRequestTimeout);

    return _processResponse(response);
  }

  Future<dynamic> put(String url, [Map<String, dynamic> data]) async {
    var headers = await _getHeaders();
    _log('HTTP.put', url);
    http.Response response = await http.put(Uri.encodeFull(url), body: _normalizeBody(data) , headers: headers).timeout(HTTP_TIMEOUT, onTimeout: _onRequestTimeout);

    return _processResponse(response);
  }

  Future<dynamic> delete(String url, [Map<String, dynamic> params]) async {
    if (params != null) {
      url = url + '?' + RequestBuilderUtil.buildGetUrl(params);
    }
    _log('HTTP.delete', url);
    var headers = await _getHeaders();
    http.Response response = await http.delete(Uri.encodeFull(url), headers: headers).timeout(HTTP_TIMEOUT, onTimeout: _onRequestTimeout);

    return _processResponse(response);
  }

  Future<dynamic> postWithStream(String url, File file, [ Map<String, dynamic> params ]) async {
    final uri = Uri.parse(url);
    final request = new http.MultipartRequest("POST", uri);
    Completer completer = new Completer();

    final headers = await _getHeaders(true);
    request.headers.addAll(headers);

    if (params != null) {
      params.forEach((key, value) {
        request.fields[key] = _encoder.convert(value);
      });
    }

    final stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    final fileLength = await file.length();

    request.files.add(
      new http.MultipartFile("file", stream, fileLength,
        filename: basename(file.path),
        contentType: new MediaType("image", "png")
      )
    );

    final response = await request.send();
    print(response.statusCode);

    if (response.statusCode != 200){
      completer.complete(null);
    }else{
      response.stream.transform(utf8.decoder).listen((value) async {
        print(value);
        BaseResultEntity result = await compute(_parseResult, value);
        completer.complete(result);
      });
    }

    return completer.future;
  }
  void _log(String tag, String msg) {
    if(logger != null) {
      logger.log(tag, msg);
    }
  }
}
