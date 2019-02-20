class ResultDataModel {
  dynamic result;
  ErrorModel error;
  StatusResponse status = StatusResponse.SUCCESS;
}

enum StatusResponse { SUCCESS, FAILURE }

class ErrorModel {
  String code = '';
  String message = '';
}

class BaseModel {
  static String parseString(String forKey, Map<String, dynamic> json) {
    var result = '';
    result = json[forKey].toString() ?? '';
    if (result.toLowerCase().contains('null')) {
      return '';
    }
    return result;
  }

  static bool parseBool(String forKey, Map<String, dynamic> json) {
    var result = false;
    result = json[forKey] ?? false;
    return result;
  }

  static List parseList(String forKey, Map<String, dynamic> json) {
    if (json.containsKey(forKey)) {
      final list = json[forKey] as List;
      return list;
    }

    return new List();
  }

  static double parseDouble(String forKey, Map<String, dynamic> json) {
    double result = 0.0;
    result = json[forKey] ?? 0.0;
    return result;
  }

  static Map<String, dynamic> parseMap(
      String forKey, Map<String, dynamic> json) {
    Map<String, dynamic> result = Map<String, dynamic>();
    // if (json.containsKey(forKey)) {
    result = Map<String, dynamic>.from(json[forKey] ?? Map<String, dynamic>());
    // }

    return result;
  }

  static List<Map<String, dynamic>> parseArrayMap(
      String forKey, Map<String, dynamic> json) {
    List<Map<String, dynamic>> result = new List();
    result = json[forKey] ?? List();
    return result;
  }

}
