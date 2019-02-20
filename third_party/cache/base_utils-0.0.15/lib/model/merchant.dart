import 'dart:convert';

import 'package:base_utils/model/rest.dart';
import 'package:base_utils/utils/number_utils.dart';
import 'package:base_utils/utils/string_utils.dart';

class Auth {
  String token;
  String refreshToken;
  int walletId;

  Auth({
    this.token,
    this.refreshToken,
    this.walletId,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        token: json["token"],
        refreshToken: json["refreshToken"],
        walletId: json["walletId"],
      );
}

class RestAuth extends AbsRest {
  Auth data;

  RestAuth({this.data});

  factory RestAuth.fromJson(Map<String, dynamic> json) {
    RestAuth rest = RestAuth(data: Auth.fromJson(json['data']));
    rest.error = ErrorMessage.fromJson(json['error']);
    return rest;
  }
}

MerchantUserInfo merchantUserInfoFromJson(String str) {
  final jsonData = json.decode(str);
  return MerchantUserInfo.fromJson(jsonData);
}

String merchantUserInfoToJson(MerchantUserInfo data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class MerchantUserInfo {
  String accessToken;
  String senpayToken;
  var userId;
  var birthday;
  var status;
  String email;
  var createdTime;
  var gender;
  String lastName;
  String firstName;
  String fullName;
  var fptId;
  String avatarUrl;
  String phone;
  String avatar;
  String chatToken;
  String userName;
  var verifyMyPhone;
  var verifyMyEmail;
  var canUpdateEmail;
  var canUpdatePhone;

  MerchantUserInfo({
    this.accessToken,
    this.senpayToken,
    this.userId,
    this.birthday,
    this.status,
    this.email,
    this.createdTime,
    this.gender,
    this.lastName,
    this.firstName,
    this.fullName,
    this.fptId,
    this.avatarUrl,
    this.phone,
    this.avatar,
    this.chatToken,
    this.userName,
    this.verifyMyPhone,
    this.verifyMyEmail,
    this.canUpdateEmail,
    this.canUpdatePhone,
  });

  bool isVerifyMyPhone() {
    return verifyMyPhone != null &&
        (verifyMyPhone == 1 || verifyMyPhone == "1" || verifyMyPhone == true);
  }

  factory MerchantUserInfo.fromJson(Map<String, dynamic> json) =>
      new MerchantUserInfo(
        accessToken: json["access_token"] == null ? null : json["access_token"],
        senpayToken: json["senpay_token"] == null ? null : json["senpay_token"],
        userId: json["user_id"] == null ? null : json["user_id"],
        birthday: json["birthday"] == null ? null : json["birthday"],
        status: json["status"] == null ? null : json["status"],
        email: json["email"] == null ? null : json["email"],
        createdTime: json["created_time"] == null ? null : json["created_time"],
        gender: json["gender"] == null ? null : json["gender"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        fullName: json["full_name"] == null ? null : json["full_name"],
        fptId: json["fpt_id"] == null ? null : json["fpt_id"],
        avatarUrl: json["avatar_url"] == null ? null : json["avatar_url"],
        phone: json["phone"] == null ? null : json["phone"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        chatToken: json["chat_token"] == null ? null : json["chat_token"],
        userName: json["user_name"] == null ? null : json["user_name"],
        verifyMyPhone:
            json["verify_my_phone"] == null ? null : json["verify_my_phone"],
        verifyMyEmail:
            json["verify_my_email"] == null ? null : json["verify_my_email"],
        canUpdateEmail:
            json["can_update_email"] == null ? null : json["can_update_email"],
        canUpdatePhone:
            json["can_update_phone"] == null ? null : json["can_update_phone"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken == null ? null : accessToken,
        "senpay_token": senpayToken == null ? null : senpayToken,
        "user_id": userId == null ? null : userId,
        "birthday": birthday == null ? null : birthday,
        "status": status == null ? null : status,
        "email": email == null ? null : email,
        "created_time": createdTime == null ? null : createdTime,
        "gender": gender == null ? null : gender,
        "last_name": lastName == null ? null : lastName,
        "first_name": firstName == null ? null : firstName,
        "full_name": fullName == null ? null : fullName,
        "fpt_id": fptId == null ? null : fptId,
        "avatar_url": avatarUrl == null ? null : avatarUrl,
        "phone": phone == null ? null : phone,
        "avatar": avatar == null ? null : avatar,
        "chat_token": chatToken == null ? null : chatToken,
        "user_name": userName == null ? null : userName,
        "verify_my_phone": verifyMyPhone == null ? null : verifyMyPhone,
        "verify_my_email": verifyMyEmail == null ? null : verifyMyEmail,
        "can_update_email": canUpdateEmail == null ? null : canUpdateEmail,
        "can_update_phone": canUpdatePhone == null ? null : canUpdatePhone,
      };
}

class RestMerchant extends AbsRest {
  MerchantUserInfoLinked data;

  RestMerchant({this.data});

  factory RestMerchant.fromJson(Map<String, dynamic> json) {
    RestMerchant rest =
        RestMerchant(data: MerchantUserInfoLinked.fromJson(json['data']));
    rest.error = ErrorMessage.fromJson(json['error']);
    return rest;
  }
}

/**
 * Đây là thông tin liên kết ví.
 */
class MerchantUserInfoLinked {
  final bool linked;
  final Profile profile;

  MerchantUserInfoLinked({this.linked, this.profile});

  factory MerchantUserInfoLinked.fromJson(Map<String, dynamic> json) =>
      MerchantUserInfoLinked(
        linked: json['linked'],
        profile:
            json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      );
}

class Profile {
  final String phoneNumber;
  final String displayName;
  final String email;
  final WalletAccount walletAccount;
  final String message;
  final String status;
  bool accountLocked = false;

  final String STATUS_LOCKED = "16";

  Profile(
      {this.phoneNumber,
      this.displayName,
      this.email,
      this.walletAccount,
      this.message,
      this.status}) {
    if (isNotEmpty(status) && status == STATUS_LOCKED) {
      accountLocked = true;
    }
  }

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      phoneNumber: json['phoneNumber'],
      displayName: json['displayName'],
      email: json['email'],
      walletAccount: json.containsKey("walletAccount")
          ? WalletAccount.fromJson(json["walletAccount"])
          : null,
      message: json['message'],
      status: json['status']);
}

class WalletAccount {
  int accountId;
  int accountType;
  int amount;
  int freezeAmount;
  int totalAmount;
  int limitAmount;
  CashbackWallet cashbackWallet;
  String confirmationName;
  String type;
  String isAuthentication;

  WalletAccount({
    this.accountId,
    this.accountType,
    this.amount,
    this.freezeAmount,
    this.totalAmount,
    this.limitAmount,
    this.cashbackWallet,
    this.confirmationName,
    this.type,
    this.isAuthentication,
  });

  factory WalletAccount.fromJson(Map<String, dynamic> json) =>
      new WalletAccount(
        accountId: json["accountId"],
        accountType: json["accountType"],
        amount: json["amount"],
        freezeAmount: json["freeze_amount"],
        totalAmount: json["total_amount"],
        limitAmount: json["limit_amount"],
        cashbackWallet: json["cashback_wallet"] != null
            ? CashbackWallet.fromJson(json["cashback_wallet"])
            : null,
        confirmationName: json["confirmationName"],
        type: json["type"],
        isAuthentication: json["isAuthentication"],
      );
}

class CashbackWallet {
  int balance;
  int expTime;

  CashbackWallet({
    this.balance,
    this.expTime,
  });

  factory CashbackWallet.fromJson(Map<String, dynamic> json) =>
      new CashbackWallet(
        balance: isNumValid(json["balance"]) ? (json["balance"]) : 0,
        expTime: isNumValid(json["expTime"]) ? json["expTime"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "expTime": expTime,
      };
}
