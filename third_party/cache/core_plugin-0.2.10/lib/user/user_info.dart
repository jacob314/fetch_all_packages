import 'package:core_plugin/base_model.dart';

class UserInfo {
  final String userId;
  final String senpayToken;
  final String birthday;
  final String status;
  final String email;
  final String createdTime;
  final String gender;
  final String lastName;
  final String firstName;
  final String fptId;
  final String avatarUrl;
  final String fullName;
  final String phone;
  final String chatToken;
  final String accessToken;
  final String userType;
  final String loyaltyPointTotal;
  final String orderTotal;
  final String favoriteProductTotal;
  final String favoriteShopTotal;
  final String commentTotal;
  final String verifyMyPhone;
  final String canUpdateEmail;
  final String canUpdatePhone;
  final String tokenOTP;
  final String userName;
  final String showPopupOtp = '';
  final String strLogin = '';
  final String loginType = '';
  final String message = '';
  final String errorCode = '';

  UserInfo({this.userId,
    this.senpayToken,
    this.birthday,
    this.status,
    this.email,
    this.createdTime,
    this.gender,
    this.lastName,
    this.firstName,
    this.fptId,
    this.avatarUrl,
    this.fullName,
    this.phone,
    this.chatToken,
    this.accessToken,
    this.userType,
    this.loyaltyPointTotal,
    this.orderTotal,
    this.favoriteProductTotal,
    this.favoriteShopTotal,
    this.commentTotal,
    this.verifyMyPhone,
    this.canUpdateEmail,
    this.canUpdatePhone,
    this.tokenOTP,
    this.userName});

  UserInfo.fromJson(Map<String, dynamic> json)
      : userId = BaseModel.parseString('user_id', json),
        senpayToken = BaseModel.parseString('senpay_token', json),
        birthday = BaseModel.parseString('birthday', json),
        status = BaseModel.parseString('status', json),
        email = BaseModel.parseString('email', json),
        createdTime = BaseModel.parseString('created_time', json),
        gender = BaseModel.parseString('gender', json),
        lastName = BaseModel.parseString('last_name', json),
        firstName = BaseModel.parseString('first_name', json),
        fptId = BaseModel.parseString('fpt_id', json),
        avatarUrl = BaseModel.parseString('avatar_url', json),
        fullName = BaseModel.parseString('full_name', json),
        phone = BaseModel.parseString('phone', json),
        chatToken = BaseModel.parseString('chat_token', json),
        accessToken = BaseModel.parseString('access_token', json),
        userType = BaseModel.parseString('user_type', json),
        loyaltyPointTotal = BaseModel.parseString('loyalty_point_total', json),
        orderTotal = BaseModel.parseString('order_total', json),
        favoriteProductTotal =
        BaseModel.parseString('favorite_product_total', json),
        favoriteShopTotal = BaseModel.parseString('favorite_shop_total', json),
        commentTotal = BaseModel.parseString('comment_total', json),
        verifyMyPhone = BaseModel.parseString('verify_my_phone', json),
        canUpdateEmail = BaseModel.parseString('can_update_email', json),
        canUpdatePhone = BaseModel.parseString('can_update_phone', json),
        tokenOTP = BaseModel.parseString('token_otp', json),
        userName = BaseModel.parseString('user_name', json);

  Map<String, dynamic> toJson() =>
      {
        'user_id': userId,
        'senpay_token': senpayToken,
        'birthday': birthday,
        'status': status,
        'email': email,
        'created_time': createdTime,
        'gender': gender,
        'last_name': lastName,
        'first_name': firstName,
        'fpt_id': fptId,
        'avatar_url': avatarUrl,
        'full_name': fullName,
        'phone': phone,
        'chat_token': chatToken,
        'access_token': accessToken,
        'user_type': userType,
        'loyalty_point_total': loyaltyPointTotal,
        'order_total': orderTotal,
        'favorite_product_total': favoriteProductTotal,
        'favorite_shop_total': favoriteShopTotal,
        'comment_total': commentTotal,
        'verify_my_phone': verifyMyPhone,
        'can_update_email': canUpdateEmail,
        'can_update_phone': canUpdatePhone,
        'token_otp': tokenOTP,
        'user_name': userName,
        'message': message,
        'show_popup_otp': showPopupOtp,
        'error_code': errorCode,
      };
}

class CheckoutInfo {
  final String shopId;
  final String itemHash;
  final String affiliate;

  CheckoutInfo({this.shopId, this.itemHash, this.affiliate});

  CheckoutInfo.fromJson(Map<String, dynamic> json)
      : shopId = BaseModel.parseString('shop_id', json),
        itemHash = BaseModel.parseString('item_hash', json),
        affiliate = BaseModel.parseString('affiliate', json);
}

class DeviceInfo {
  String appVersion;
  String brand;
  String model;
  String os;
  String osVersion;
  String udid;
  String deviceId;

  DeviceInfo({
    this.appVersion,
    this.brand,
    this.model,
    this.os,
    this.osVersion,
    this.udid,
    this.deviceId,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      new DeviceInfo(
        appVersion: json["appVersion"],
        brand: json["brand"],
        model: json["model"],
        os: BaseModel.parseString('os', json),
        osVersion: json["osVersion"],
        udid: json["udid"],
        deviceId: BaseModel.parseString('deviceId', json)
      );

  Map<String, dynamic> toJson() =>
      {
        "appVersion": appVersion,
        "brand": brand,
        "model": model,
        "os": os,
        "osVersion": osVersion,
        "udid": udid,
        "deviceId": deviceId
      };
}

class ConfigInfo {
  String environment;

  ConfigInfo({
    this.environment
  });

  factory ConfigInfo.fromJson(Map<String, dynamic> json) =>
      new ConfigInfo(
        environment: json["environment"],
      );

  Map<String, dynamic> toJson() =>
      {
        "environment": environment,
      };
}
