import 'dart:convert';

IdAuthResut idAuthResutFromJson(String str) {
  final jsonData = json.decode(str);
  return IdAuthResut.fromJson(jsonData);
}

String idAuthResutToJson(IdAuthResut data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class IdAuthResut {
  String partnerOrderId;
  String sessionId;
  String success;
  String suggestResult;
  String verifyStatus;
  String message;
  String resultStatus;

  IdAuthResut({
    this.partnerOrderId,
    this.sessionId,
    this.success,
    this.suggestResult,
    this.verifyStatus,
    this.message,
    this.resultStatus,
  });

  factory IdAuthResut.fromJson(Map<dynamic, dynamic> json) => new IdAuthResut(
        partnerOrderId: json["partner_order_id"],
        sessionId: json["session_id"],
        success: json["success"],
        suggestResult: json["suggest_result"],
        verifyStatus: json["verify_status"],
        message: json["message"],
        resultStatus: json["result_status"],
      );

  Map<String, dynamic> toJson() => {
        "partner_order_id": partnerOrderId,
        "session_id": sessionId,
        "success": success,
        "suggest_result": suggestResult,
        "verify_status": verifyStatus,
        "message": message,
        "result_status": resultStatus,
      };
}
