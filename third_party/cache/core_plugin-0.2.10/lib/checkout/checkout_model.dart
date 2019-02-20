import 'package:core_plugin/base_model.dart';

class CheckoutDataModel {
  CheckoutModel data;

  CheckoutDataModel({this.data});

  factory CheckoutDataModel.fromJson(Map<String, dynamic> parsedJson) {
    return CheckoutDataModel(data: CheckoutModel.fromJson(parsedJson['data']));
  }
}

class CheckoutModel {
  CustomerInfo customerData;
  List<ShopInfo> shopInfos;

  CheckoutModel({this.customerData, this.shopInfos});

  factory CheckoutModel.fromJson(Map<String, dynamic> parsedJson) {
    List<ShopInfo> shopInfoList = new List();
    if (parsedJson.containsKey('shop_info')) {
      var list = BaseModel.parseList(
          'shop_info', parsedJson); // parsedJson['shop_info'] as List;
      shopInfoList = list.map((i) => ShopInfo.fromJson(i)).toList();
    }

    return CheckoutModel(
        customerData: CustomerInfo.fromJson(
            parsedJson['customer_data'] ?? new Map<String, dynamic>()),
        shopInfos: shopInfoList);
  }
}

class CustomerInfo {
  final CustomerData customerData;
  BadBuyerInfo badBuyerInfo;
  List<CustomerAddress> customerAddress;

  CustomerInfo({this.customerData, this.badBuyerInfo, this.customerAddress});

  factory CustomerInfo.fromJson(Map<String, dynamic> parsedJson) {
    List<CustomerAddress> customerAddressList = new List();
    if (parsedJson.containsKey('customer_address')) {
      var list = BaseModel.parseList('customer_address', parsedJson);
      customerAddressList =
          list.map((i) => CustomerAddress.fromJson(i)).toList();
    }

    return CustomerInfo(
        badBuyerInfo: BadBuyerInfo.fromJson(
            parsedJson['bad_buyer_info'] ?? new Map<String, dynamic>()),
        customerData: CustomerData.fromJson(
            parsedJson['customer_data'] ?? new Map<String, dynamic>()),
        customerAddress: customerAddressList);
  }
}

class CustomerData {
  final String customerId;
  final String fptId;
  final String telephone;
  final String firstName;
  final String lastName;
  final String email;
  final String isOtpPhone;

  CustomerData(
      {this.customerId,
      this.fptId,
      this.telephone,
      this.firstName,
      this.lastName,
      this.email,
      this.isOtpPhone});

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
        customerId: BaseModel.parseString('customer_id', json),
        fptId: BaseModel.parseString('fpt_id', json),
        telephone: BaseModel.parseString('telephone', json),
        firstName: BaseModel.parseString('firstname', json),
        lastName: BaseModel.parseString('lastname', json),
        email: BaseModel.parseString('email', json),
        isOtpPhone: BaseModel.parseString('is_otp_phone', json));
  }
}

class BadBuyerInfo {
  final bool shopBlock;

  final bool blockCod;

  final bool otpCod;

  BadBuyerInfo(
      {this.shopBlock = false, this.blockCod = false, this.otpCod = false});

  factory BadBuyerInfo.fromJson(Map<String, dynamic> json) {
    return BadBuyerInfo(
        blockCod: BaseModel.parseBool('block_cod', json), //;
        otpCod: BaseModel.parseBool('otp_cod', json), //
        shopBlock: BaseModel.parseBool('shop_block', json));
  }
}

class CustomerAddress {
  final String customerId;
  final String fptId;
  final String createdAt;
  final String addressId;
  final String firstName;
  final String lastName;
  final String city;
  final String cityId;
  final String district;
  final String districtId;
  final String ward;
  final String wardId;
  final String street;
  final String telephone;
  final String email;
  final String latitude;
  final String longitude;
  final String fullAddress;
  final bool isDefaultShipping;

  CustomerAddress(
      {this.customerId,
      this.fptId,
      this.createdAt,
      this.addressId,
      this.firstName,
      this.lastName,
      this.city,
      this.cityId,
      this.district,
      this.districtId,
      this.ward,
      this.wardId,
      this.street,
      this.telephone,
      this.email,
      this.latitude,
      this.longitude,
      this.fullAddress,
      this.isDefaultShipping});

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
        customerId: BaseModel.parseString('customer_id', json),
        fptId: BaseModel.parseString('fpt_id', json),
        createdAt: BaseModel.parseString('created_at', json),
        addressId: BaseModel.parseString('address_id', json),
        firstName: BaseModel.parseString('firstname', json),
        lastName: BaseModel.parseString('lastname', json),
        city: BaseModel.parseString('city', json),
        cityId: BaseModel.parseString('city_id', json),
        district: BaseModel.parseString('district', json),
        districtId: BaseModel.parseString('district_id', json),
        ward: BaseModel.parseString('ward', json),
        wardId: BaseModel.parseString('ward_id', json),
        street: BaseModel.parseString('street', json),
        telephone: BaseModel.parseString('telephone', json),
        email: BaseModel.parseString('email', json),
        latitude: BaseModel.parseString('latitude', json),
        longitude: BaseModel.parseString('longitude', json),
        fullAddress: BaseModel.parseString('full_address', json),
        isDefaultShipping: BaseModel.parseBool('is_default_shipping', json));
  }
}

class ShopInfo {
  final String shopId;
  final String externalId;
  final String name;
  final String shopType;
  final bool canUseSuperFastDelivery;

  ShopInfo(
      {this.shopId,
      this.externalId,
      this.name,
      this.shopType,
      this.canUseSuperFastDelivery});

  factory ShopInfo.fromJson(Map<String, dynamic> json) {
    return ShopInfo(
        shopId: BaseModel.parseString('shop_id', json),
        externalId: BaseModel.parseString('external_id', json),
        name: BaseModel.parseString('name', json),
        shopType: BaseModel.parseString('shop_type', json),
        canUseSuperFastDelivery:
            BaseModel.parseBool('can_use_super_fast_delivery', json));
  }
}
