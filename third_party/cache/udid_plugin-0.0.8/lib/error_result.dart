import 'dart:convert';

ErrorResut errorResutFromJson(String str) {
  final jsonData = json.decode(str);
  return ErrorResut.fromJson(jsonData);
}

String errorResutToJson(ErrorResut data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class ErrorResut {
  String retCode;
  String retMsg;

  ErrorResut({
    this.retCode,
    this.retMsg,
  });

  factory ErrorResut.fromJson(Map<dynamic, dynamic> json) => new ErrorResut(
        retCode: json["ret_code"],
        retMsg: json["ret_msg"],
      );

  Map<String, dynamic> toJson() => {
        "ret_code": retCode,
        "ret_msg": retMsg,
      };
}
