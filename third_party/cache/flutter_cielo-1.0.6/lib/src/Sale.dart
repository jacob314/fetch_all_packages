// Generated by https://quicktype.io

import 'package:flutter_cielo/src/Customer.dart';
import 'package:flutter_cielo/src/Payment.dart';

part 'Sale.g.dart';

class Sale {
  String merchantOrderId;
  Customer customer;
  Payment payment;

  Sale({
    this.merchantOrderId,
    this.customer,
    this.payment,
  }) {
    if (this.customer == null) this.customer = Customer();
    if (this.payment == null) this.payment = Payment();
  }

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);
  Map<String, dynamic> toJson() => _$SaleToJson(this);
}