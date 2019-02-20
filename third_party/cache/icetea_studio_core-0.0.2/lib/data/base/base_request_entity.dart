import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(createFactory: false, createToJson: false)
class BaseRequestEntity {

  Map<String, dynamic> toJson() => new Map();
  
  String toJsonString() {
    final map = this.toJson();
    if (map != null){
      return json.encode(map);
    }
    return "";
  }
}