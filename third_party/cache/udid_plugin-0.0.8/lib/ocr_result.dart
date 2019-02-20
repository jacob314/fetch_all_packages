import 'dart:convert';

OcrResut ocrResutFromJson(String str) {
  final jsonData = json.decode(str);
  return OcrResut.fromJson(jsonData);
}

String ocrResutToJson(OcrResut data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class OcrResut {
  String address;
  String age;
  String birthday;
  String gender;
  String idName;
  String idNumber;
  String idcardBackPhoto;
  String idcardFrontPhoto;
  String idcardPortraitPhoto;
  String issuingAuthority;
  String nation;
  String partnerOrderId;
  String validityPeriod;
  String validityPeriodExpired;
  String message;
  String sessionId;
  String success;

  OcrResut({
    this.address,
    this.age,
    this.birthday,
    this.gender,
    this.idName,
    this.idNumber,
    this.idcardBackPhoto,
    this.idcardFrontPhoto,
    this.idcardPortraitPhoto,
    this.issuingAuthority,
    this.nation,
    this.partnerOrderId,
    this.validityPeriod,
    this.validityPeriodExpired,
    this.message,
    this.sessionId,
    this.success,
  });

  factory OcrResut.fromJson(Map<dynamic, dynamic> json) => new OcrResut(
        address: json["address"],
        age: json["age"],
        birthday: json["birthday"],
        gender: json["gender"],
        idName: json["id_name"],
        idNumber: json["id_number"],
        idcardBackPhoto: json["idcard_back_photo"],
        idcardFrontPhoto: json["idcard_front_photo"],
        idcardPortraitPhoto: json["idcard_portrait_photo"],
        issuingAuthority: json["issuing_authority"],
        nation: json["nation"],
        partnerOrderId: json["partner_order_id"],
        validityPeriod: json["validity_period"],
        validityPeriodExpired: json["validity_period_expired"],
        message: json["message"],
        sessionId: json["session_id"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "age": age,
        "birthday": birthday,
        "gender": gender,
        "id_name": idName,
        "id_number": idNumber,
        "idcard_back_photo": idcardBackPhoto,
        "idcard_front_photo": idcardFrontPhoto,
        "idcard_portrait_photo": idcardPortraitPhoto,
        "issuing_authority": issuingAuthority,
        "nation": nation,
        "partner_order_id": partnerOrderId,
        "validity_period": validityPeriod,
        "validity_period_expired": validityPeriodExpired,
        "message": message,
        "session_id": sessionId,
        "success": success,
      };
}
