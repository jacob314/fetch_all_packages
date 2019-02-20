import 'dart:async';

import 'package:flutter/services.dart';

// This is the official Flutter Plugin for Sensors Analytics.
class SensorsAnalyticsFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('sensors_analytics_flutter_plugin');

  static Future<String> get getDistinctId async {
    return await _channel.invokeMethod('getDistinctId');
  }

  ///
  /// track
  /// 事件追踪
  ///
  /// @param eventName  String 事件名.
  /// @param properties Map<String,dynamic> 事件属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.track('eventname',{'key1':'value1','key2':'value2'});
  ///
  static void track(String eventName ,Map<String,dynamic> properties ) {
    assert(eventName != null);
    List<dynamic> params = [eventName,properties];
    _channel.invokeMethod('track',params);
  }

  ///
  /// trackInstallation
  /// App 激活事件追踪
  ///
  /// @param eventName  String 通常为'AppInstall'.
  /// @param properties Map<String,dynamic> App 激活事件的属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.trackInstallation('AppInstall',{'key1':'value1','key2':'value2'});
  ///
  static void trackInstallation(String eventName ,Map<String,dynamic> properties ) {
    assert(eventName != null);
    List<dynamic> params = [eventName,properties];
    _channel.invokeMethod('trackInstallation',params);
  }

  ///
  /// trackTimerStart
  /// 开始计时
  ///
  /// 初始化事件的计时器，默认计时单位为秒(计时开始).
  /// @param eventName 事件的名称.
  ///
  /// 使用示例：（计时器事件名称 viewTimer ）
  /// SensorsAnalyticsFlutterPlugin.trackTimerStart('viewTimer');
  ///
  static void trackTimerStart(String eventName) {
    assert(eventName != null);
    List<String> params = [eventName];
    _channel.invokeMethod('trackTimerStart',params);
  }

  ///
  /// trackTimerEnd
  /// 计时结束
  ///
  /// 初始化事件的计时器，默认计时单位为秒(计时开始).
  /// @param eventName 事件的名称.
  /// @param properties Map<String,dynamic> 事件属性.
  ///
  /// 使用示例：（计时器事件名称 viewTimer ）
  /// SensorsAnalyticsFlutterPlugin.trackTimerEnd('viewTimer',{});
  ///
  static void trackTimerEnd(String eventName ,Map<String,dynamic> properties ) {
    assert(eventName != null);
    List<dynamic> params = [eventName,properties];
    _channel.invokeMethod('trackTimerEnd',params);
  }


  ///
  /// clearTrackTimer
  /// 清除所有事件计时器
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.clearTrackTimer();
  ///
  static void clearTrackTimer() {
    _channel.invokeMethod('clearTrackTimer');
  } 

  ///
  /// login.
  /// 用户登陆
  /// @param loginId 用户登录 ID.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.login('login_id');
  ///
  static void login(String loginId){
    assert(loginId != null);
    List<String> params = [loginId];
    _channel.invokeMethod('login',params);
  }

  ///
  /// logout
  /// 用户登出
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.logout();
  ///
  static void logout(){
    _channel.invokeMethod('logout');
  }

  ///
  /// trackViewScreen 
  /// 页面浏览
  ///
  /// @param url String 页面标示.
  /// @param properties Map<String,dynamic> 事件属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.trackViewScreen('urlForView',{'key1':'value1','key2':'value2'});
  ///
  static void trackViewScreen(String url ,Map<String,dynamic> properties ) {
    assert(url != null);
    List<dynamic> params = [url,properties];
    _channel.invokeMethod('trackViewScreen',params);
  }  


  ///
  /// profileSet 
  /// 设置用户属性值
  ///
  /// @param profileProperties Map<String,dynamic> 用户属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileSet({'key1':'value1','key2':'value2'});
  ///
  static void profileSet(Map<String,dynamic> profileProperties){
    List<dynamic> params = [profileProperties];
    _channel.invokeMethod('profileSet',params);
  }

  ///
  /// profileSetOnce 
  /// 设置用户属性值，与 profileSet 不同的是：如果之前存在，则忽略，否则，新创建.
  ///
  /// @param profileProperties Map<String,dynamic> 用户属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileSetOnce({'key1':'value1','key2':'value2'});
  ///
  static void profileSetOnce(Map<String,dynamic> profileProperties){
    List<dynamic> params = [profileProperties];
    _channel.invokeMethod('profileSetOnce',params);
  }

  ///
  /// profileUnset 
  /// 删除一个用户属性.
  ///
  /// @param profilePropertity String 用户属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileUnset('key1');
  ///
  static void profileUnset(String profilePropertity){
    List<dynamic> params = [profilePropertity];
    _channel.invokeMethod('profileUnset',params);
  } 

  ///
  /// profileIncrement 
  /// 给一个数值类型的Profile增加一个数值. 只能对数值型属性进行操作，若该属性未设置，则添加属性并设置默认值为0
  ///
  /// @param profilePropertity String 用户属性.
  /// @param number 增加的数值，可以为负数
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileIncrement('age',10);
  ///
  static void profileIncrement(String profilePropertity, num number) {
    List<dynamic> params = [profilePropertity,number];
    _channel.invokeMethod('profileIncrement',params);
  }

  ///
  /// profileAppend 
  /// 给一个 List 类型的 Profile 增加一些值
  ///
  /// @param profilePropertity String 用户属性.
  /// @param content List<String> 增加的值，List 中元素必须为 String
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileAppend('address',['Beijing','Shanghai']);
  ///
  static void profileAppend(String profilePropertity, List<String> content) {
    List<dynamic> params = [profilePropertity,content];
    _channel.invokeMethod('profileAppend',params);
  }


  ///
  /// profileDelete 
  /// 删除当前用户的所有记录
  /// 
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileDelete();
  ///
  static void profileDelete() {
    _channel.invokeMethod('profileDelete');
  } 
  
  ///
  /// clearKeychainData 
  /// 删除当前 keychain 记录 (仅 iOS 使用)
  /// 
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.clearKeychainData();
  ///
  static void clearKeychainData() {
    _channel.invokeMethod('clearKeychainData');
  } 

}
