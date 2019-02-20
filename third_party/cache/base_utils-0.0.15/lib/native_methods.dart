import 'dart:async';

import 'package:base_utils/model/merchant.dart';
import 'package:base_utils/utils/logging_utils.dart';
import 'package:base_utils/utils/string_utils.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

const nativeChannel = MethodChannel('com.sendo.flutter.io/native');

Future<dynamic> actionDeepLinkSendo({@required String url}) async {
  try {
    final dict = {'url': url};
    await nativeChannel.invokeMethod('actionDeepLink', [dict]);
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionShareSendo(
    {@required String shareUrl,
    String option,
    String title,
    String desc,
    String imageLink}) async {
  try {
    log("shareUrl: $shareUrl, option: $option, title: $title, desc: $desc, imageLink: $imageLink");
    final dict = {
      'shareUrl': shareUrl,
      'option': option,
      'title': title,
      'desc': desc,
      'imageLink': imageLink
    };
    await nativeChannel.invokeMethod('actionShare', [dict]);
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionShareFacebook({@required String shareUrl}) async {
  try {
    final dict = {'shareUrl': shareUrl};
    await nativeChannel.invokeMethod('actionShareFacebook', [dict]);
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionGetSendoUserInfo() async {
  try {
    var tmp = await nativeChannel.invokeMethod('actionGetUserInfo');
    if (tmp is String) {
      log("actionGetSendoUserInfo: $tmp ===> is String");
      if (isNotEmpty(tmp)) return merchantUserInfoFromJson(tmp);
    } else {
      log("actionGetSendoUserInfo: $tmp ===> is Map");
      if (tmp != null)
        return MerchantUserInfo.fromJson(Map<String, dynamic>.from(tmp));
    }
  } on PlatformException catch (e) {
    log(e);
  }
  return null;
}

Future<dynamic> actionProductDetailSendo({@required String id}) async {
  try {
    final dict = {'id': id};
    await nativeChannel.invokeMethod('actionProductDetail', [dict]);
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionOpenWebView(
    {@required String url, String title, List<dynamic> menu}) async {
  try {
    final dict = {
      'url': url,
      'title': title,
      'menu': menu,
    };
    return nativeChannel.invokeMethod('actionOpenWebView', [dict]);
  } on PlatformException catch (e) {
    log(e);
  }
  return null;
}

Future<dynamic> actionCloseScreen([bool animated = true]) async {
  try {
    final dict = {
      'animated': animated,
    };
    await nativeChannel.invokeMethod('actionCloseScreen', [dict]);
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionSaveProductToListFavorite(
    {@required int productId}) async {
  String _productId = '${productId}';
  try {
    final dict = {'productId': _productId};
    await nativeChannel.invokeMethod('actionSaveProductToListFavorite', [dict]);
  } on PlatformException catch (e) {
    log(e);
  }
}

// todo Call method action deeplink
Future<dynamic> actionOpenFavorite() async {
  try {
    await nativeChannel.invokeMethod('actionOpenFavorite');
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionLoginSendo({@required String screenName}) async {
  try {
    final dict = {'screenName': screenName};
    return await nativeChannel.invokeMethod('actionLoginEvent', [dict]);
  } on PlatformException catch (e) {
    log(e);
  }
  return null;
}

Future<dynamic> actionOpenVoucher() async {
  try {
    await actionDeepLinkSendo(
        url: 'https://www.sendo.vn/thong-tin-tai-khoan/ma-giam-gia');
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionVerifyPhone() async {
  try {
    await actionDeepLinkSendo(url: "https://www.sendo.vn/thong-tin-tai-khoan");
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionSenPayTransactionHistory() async {
  try {
    await actionDeepLinkSendo(
        url: "https://www.sendo.vn/thong-tin-tai-khoan/tai-khoan-senpay");
  } on PlatformException catch (e) {
    log(e);
  }
}

Future<dynamic> actionGetUDID() async {
  try {
    return await nativeChannel.invokeMethod('actionGetUDID');
  } on PlatformException catch (e) {
    log(e);
  }
  return null;
}
