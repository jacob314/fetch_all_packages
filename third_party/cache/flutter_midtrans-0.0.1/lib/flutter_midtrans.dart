import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Midtrans {
  static const _channel = const MethodChannel('flutter_midtrans');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///init midtrans sdk flow
  static initSdkFlow(
      {@required String clientKey,
      String primaryColor = "#FFE51255",
      String secondaryColor = "#B61548",
      String accentColor = "#FFE51255"}) {
    _channel.invokeMethod("initSdkFlow", {
      'clientKey': clientKey,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
      'accentColor': accentColor
    });
  }

  ///create transaction
  static createTransaction(
      {@required String transId, MidtransUser user, List<MidtransItem> items}) {
    final amount = items.fold(0, (t, i) => t + i.price * i.quantity);
    _channel.invokeMethod("createTransaction", {
      'transId': transId,
      'amount': amount,
      'items': items,
      'user_details': user
    });
  }
}

///Midtrans user detail for customer
class MidtransUser {
  String fullName, email, uid;

  MidtransUser(
    this.fullName,
    this.email,
    this.uid,
  );

  Map<String, String> toMap() => {
        'fullName': fullName,
        'email': email,
        'uid': uid,
      };
}

///Midtrans result response
class MidtransResult {
  bool canceled;
  String transactionId, source, status, message;

  MidtransResult.fromMap(map) {
    canceled = map['canceled'].toString().toLowerCase() == 'true';
    source = map['source'].toString();
    status = map['status'].toString();
    message = map['message'].toString();
    transactionId = map['transactionId'].toString();
  }

  Map<String, String> toMap() => {
        'canceled': '$canceled',
        'source': source,
        'status': status,
        'message': message,
        'transactionId': transactionId,
      };
}

///Midtrans items
class MidtransItem {
  String id, name;
  int price, quantity;

  MidtransItem(this.id, this.name, this.price, this.quantity);

  Map toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
      };
}
