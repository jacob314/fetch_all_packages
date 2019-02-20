import 'dart:convert';

CompareResut compareResutFromJson(String str) {
  final jsonData = json.decode(str);
  return CompareResut.fromJson(jsonData);
}

String compareResutToJson(CompareResut data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class CompareResut {
  String partnerOrderId;
  Thresholds thresholds;
  String similarity;
  String sessionId;
  String success;
  String suggestResult;
  String message;

  CompareResut({
    this.partnerOrderId,
    this.thresholds,
    this.similarity,
    this.sessionId,
    this.success,
    this.suggestResult,
    this.message,
  });

  factory CompareResut.fromJson(Map<String, dynamic> json) => new CompareResut(
        partnerOrderId: json["partner_order_id"],
        thresholds: Thresholds.fromJson(json["thresholds"]),
        similarity: json["similarity"],
        sessionId: json["session_id"],
        success: json["success"],
        suggestResult: json["suggest_result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "partner_order_id": partnerOrderId,
        "thresholds": thresholds.toJson(),
        "similarity": similarity,
        "session_id": sessionId,
        "success": success,
        "suggest_result": suggestResult,
        "message": message,
      };
}

class Thresholds {
  String the1E5;
  String the1E4;
  String the1E3;

  Thresholds({
    this.the1E5,
    this.the1E4,
    this.the1E3,
  });

  factory Thresholds.fromJson(Map<dynamic, dynamic> json) => new Thresholds(
        the1E5: json["1e-5"],
        the1E4: json["1e-4"],
        the1E3: json["1e-3"],
      );

  Map<String, dynamic> toJson() => {
        "1e-5": the1E5,
        "1e-4": the1E4,
        "1e-3": the1E3,
      };
}
