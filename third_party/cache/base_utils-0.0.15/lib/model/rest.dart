import 'dart:convert';

ErrorMessage errorMessageFromJson(String str) {
  final jsonData = json.decode(str);
  return ErrorMessage.fromJson(jsonData);
}

String errorMessageToJson(ErrorMessage data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ErrorMessage {
  int status;
  String message;

  ErrorMessage({
    this.status,
    this.message,
  });

  factory ErrorMessage.fromJson(Map<String, dynamic> json) => new ErrorMessage(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };

  bool isSuccess() {
    return status == 1;
  }
}

AbsRest absRestFromJson(String str) {
  final jsonData = json.decode(str);
  return AbsRest.fromJson(jsonData);
}

String absRestToJson(AbsRest data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AbsRest {
  ErrorMessage error;

  AbsRest({
    this.error,
  });

  factory AbsRest.fromJson(Map<String, dynamic> json) => new AbsRest(
        error: ErrorMessage.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error.toJson(),
      };
}
