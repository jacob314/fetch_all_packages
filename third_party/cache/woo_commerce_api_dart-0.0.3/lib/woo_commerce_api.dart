library woo_commerce_api;

import 'dart:async';
import "dart:collection";
import 'dart:convert';
import "dart:math";
import "dart:core";
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;

class WooCommerceAPI {
  var url;
  var consumerKey;
  var consumerSecret;

  WooCommerceAPI(url, consumerKey, consumerSecret) {
    this.url = url;
    this.consumerKey = consumerKey;
    this.consumerSecret = consumerSecret;
  }

  _getOAuthURL(String requestMethod, String endpoint) {
    var consumerKey = this.consumerKey;
    var consumerSecret = this.consumerSecret;
    var token = "";
    var url = this.url + "/wp-json/wc/v2/" + endpoint;
    var containsQueryParams = url.contains("?");

    var rand = new Random();
    var codeUnits = new List.generate(10, (index) {
      return rand.nextInt(26) + 97;
    });

    var nonce = new String.fromCharCodes(codeUnits);
    int timestamp = (new DateTime.now().millisecondsSinceEpoch ~/ 1000);

//    print(timestamp);
//    print(nonce);

    var method = requestMethod;
    var parameters = "oauth_consumer_key=" +
        consumerKey +
        "&oauth_nonce=" +
        nonce +
        "&oauth_signature_method=HMAC-SHA1&oauth_timestamp=" +
        timestamp.toString() +
        "&oauth_token=" +
        token +
        "&oauth_version=1.0&";

    if (containsQueryParams == true) {
      parameters = parameters + url.split("?")[1];
    } else {
      parameters = parameters.substring(0, parameters.length - 1);
    }

    Map<dynamic, dynamic> params = parse(parameters);
    Map<dynamic, dynamic> treeMap = new SplayTreeMap<dynamic, dynamic>();
    treeMap.addAll(params);

    String parameterString = "";

    for (var key in treeMap.keys) {
      parameterString = parameterString +
          Uri.encodeQueryComponent(key) +
          "=" +
          treeMap[key] +
          "&";
    }

    parameterString = parameterString.substring(0, parameterString.length - 1);

    var baseString = method +
        "&" +
        Uri.encodeQueryComponent(
            containsQueryParams == true ? url.split("?")[0] : url) +
        "&" +
        Uri.encodeQueryComponent(parameterString);

    print(baseString);

    var signingKey = consumerSecret + "&" + token;
    print(signingKey);
    print(utf8.encode(signingKey));
    var hmacSha1 =
        new crypto.Hmac(crypto.sha1, utf8.encode(signingKey)); // HMAC-SHA1
    var signature = hmacSha1.convert(utf8.encode(baseString));

    print(signature);

    var finalSignature = base64Encode(signature.bytes);
    print(finalSignature);

    var requestUrl = "";

    if (containsQueryParams == true) {
      print(url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature));
      requestUrl = url.split("?")[0] +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);
    } else {
      print(url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature));
      requestUrl = url +
          "?" +
          parameterString +
          "&oauth_signature=" +
          Uri.encodeQueryComponent(finalSignature);

//      if(method != 'GET') {
//        requestUrl += "&_method="+method;
//      }
    }

    return requestUrl;
  }

  Future<List<dynamic>> getAsync(String endPoint) async {
    var url = this._getOAuthURL("GET", endPoint);
    final response = await http.get(url);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> postAsync(String endPoint, data,
      [authToken]) async {
    var url = this._getOAuthURL("POST", endPoint);
    final headers = authToken ? authToken : {};
    final response = await http.post(url, body: data, headers: headers);
    return json.decode(response.body);
  }

  Map parse(String query) {
    var search = new RegExp('([^&=]+)=?([^&]*)');
    var result = new Map();

    // Get rid off the beginning ? in query strings.
    if (query.startsWith('?')) query = query.substring(1);

    // A custom decoder.
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    // Go through all the matches and build the result map.
    for (Match match in search.allMatches(query)) {
      result[decode(match.group(1))] = decode(match.group(2));
    }

    return result;
  }
}
