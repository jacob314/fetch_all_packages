import 'dart:async';
import 'dart:convert';

import 'package:core_plugin/user/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserPreference {
  UserPreference();

  factory UserPreference.initial() => UserPreference();

  saveUserInfo(String userInfo) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userInfo', userInfo);
  }

  Future<UserInfo> getUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString('userInfo')!= null) {
      Map userMap = json.decode(prefs.getString('userInfo'));
      return new UserInfo.fromJson(userMap);
    }

    return null;
  }

//  Future<CheckoutInfo> getCheckoutInfo() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//
//    if(prefs.getString('userInfo')!= null) {
//      Map userMap = json.decode(prefs.getString('userInfo'));
//      return new UserInfo.fromJson(userMap);
//    }
//
//    return null;
//  }


  Future<bool> isLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString('userInfo')!= null) {
      Map userMap = json.decode(prefs.getString('userInfo'));
      var userInfo = UserInfo.fromJson(userMap);
      if(userInfo!= null && userInfo.accessToken != null){
        return true;
      }
    }

    return false;
  }
}