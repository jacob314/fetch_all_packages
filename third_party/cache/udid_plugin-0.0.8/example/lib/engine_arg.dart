import 'package:intl/intl.dart';

class EngieArg {
  final String pubKey = "pubKey";
  final String singTime = DateFormat('yyyyMMddHHmmss').format(new DateTime.now());
  final String partnerOrderId = "partnerOrderId";
  final String notifyUrl = "notifyUrl";
  final String sign = "sign";

  Map<String, dynamic> toJson() => {
        "pubKey": pubKey,
        "singTime": singTime,
        "partnerOrderId": partnerOrderId,
        "notifyUrl": notifyUrl,
        "sign": sign,
      };
}
