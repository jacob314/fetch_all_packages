import 'dart:convert';

LivenessResult livenessResultFromJson(String str) {
  final jsonData = json.decode(str);
  return LivenessResult.fromJson(jsonData);
}

String livenessResultToJson(LivenessResult data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LivenessResult {
  String partnerOrderId;
  RiskTag riskTag;
  String livingPhoto;
  String sessionId;
  String success;
  String message;

  LivenessResult({
    this.partnerOrderId,
    this.riskTag,
    this.livingPhoto,
    this.sessionId,
    this.success,
    this.message,
  });

  factory LivenessResult.fromJson(Map<dynamic, dynamic> json) =>
      new LivenessResult(
        partnerOrderId: json["partner_order_id"],
        riskTag: RiskTag.fromJson(json["risk_tag"]),
        livingPhoto: json["living_photo"],
        sessionId: json["session_id"],
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "partner_order_id": partnerOrderId,
        "risk_tag": riskTag.toJson(),
        "living_photo": livingPhoto,
        "session_id": sessionId,
        "success": success,
        "message": message,
      };
}

class RiskTag {
  String livingAttack;

  RiskTag({
    this.livingAttack,
  });

  factory RiskTag.fromJson(Map<String, dynamic> json) => new RiskTag(
        livingAttack: json["living_attack"],
      );

  Map<String, dynamic> toJson() => {
        "living_attack": livingAttack,
      };
}
