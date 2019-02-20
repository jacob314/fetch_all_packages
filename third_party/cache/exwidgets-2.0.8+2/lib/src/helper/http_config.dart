import 'dart:convert';
import 'package:http/http.dart' as http;

class ExHTTP {
  static String username = 'admin@anagatadev.com';
  static String password = 'Cl2TrZ7ljLCua6P3W85EVUR183eh30W7';
  static String getBasicAuth() {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    return basicAuth;
  }

  static Future<dynamic> get({
    String url,
    bool noHeader = false,
  }) async {
    print(url);

    var response;
    if (noHeader == false) {
      response = await http
          .get(url, headers: {'authorization': ExHTTP.getBasicAuth()});
    } else {
      response = await http.get(url);
    }

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("HTTP ERROR");
      print(response.body);
      return response.body;
    }
  }

  static Future<dynamic> delete({
    String url,
    bool noHeader = false,
  }) async {
    print(url);

    var response;
    if (noHeader == false) {
      response = await http
          .delete(url, headers: {'authorization': ExHTTP.getBasicAuth()});
    } else {
      response = await http.get(url);
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("HTTP ERROR");
      print(response.body);
      return response.body;
    }
  }

  static Future<dynamic> post({
    String url,
    bool noHeader = false,
    dynamic data,
  }) async {
    print(url);

    var response;
    if (noHeader == false) {
      response = await http.post(url,
          headers: {
            'authorization': ExHTTP.getBasicAuth(),
            "Content-Type": "application/json",
          },
          body: data);
    } else {
      response = await http.get(url);
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("HTTP ERROR");
      print(response.body);
      return response.body;
    }
  }

  static Future<dynamic> put({  
    String url,
    bool noHeader = false,
    dynamic data,
  }) async {
    print(url);

    var response;
    if (noHeader == false) {
      response = await http.put(url,
          headers: {
            'authorization': ExHTTP.getBasicAuth(),
            'Content-Type': 'application/json',
          },
          body: data);
    } else {
      response = await http.get(url);
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("HTTP ERROR");
      print(response.body);
      return response.body;
    }
  }
}
