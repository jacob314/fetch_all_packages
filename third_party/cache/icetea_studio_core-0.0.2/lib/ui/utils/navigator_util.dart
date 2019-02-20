import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

class NavigatorUtil {
  static GlobalKey<NavigatorState> _appNavigatorKey;

  static final JsonEncoder _encoder = new JsonEncoder();

  static String _buildRouteName(String routeName, Map<String, dynamic> params) {
    if (params == null || params.isEmpty) {
      return routeName;
    }

    String encodedParams = _encoder.convert(params);

    return '$routeName?params=$encodedParams';
  }

  static void setNavigatorKey(GlobalKey key) {
    _appNavigatorKey = key;
  }

  static Future<Object> push(BuildContext context, String routeName, [Map<String, dynamic> params]) {
    return Navigator.of(context).pushNamed(_buildRouteName(routeName, params));
  }

  static Future<Object> pushAndRemove(BuildContext context, String routeName, [Map<String, dynamic> params]) {
    return Navigator.of(context).pushNamedAndRemoveUntil(_buildRouteName(routeName, params), (_)=>false);
  }

  static Future<Object> pushReplacement(BuildContext context, String routeName, [Map<String, dynamic> params]) {
    return Navigator.of(context).pushReplacementNamed(_buildRouteName(routeName, params));
  }

  static Future<Object> pushWithState(NavigatorState state, String routeName, [Map<String, dynamic> params]) {
    return state.pushNamed(_buildRouteName(routeName, params));
  }

  static Future<Object> pushWithStateAndRemoveUtil(NavigatorState state, String routeName, Map<String, dynamic> params, RoutePredicate predicate) {
    return state.pushNamedAndRemoveUntil(_buildRouteName(routeName, params), predicate);
  }

  static bool isCurrentRoute(String routeName, [List<String> params]) {
    try {
      String currentRouteName;
      _appNavigatorKey.currentState.popUntil((route) {
        currentRouteName = route.settings?.name;
        return true;
      });
      if (currentRouteName == null) {
        return false;
      }

      bool isCurrent = currentRouteName.contains(routeName);
      if (params != null && params.isNotEmpty) {
        params.forEach((p) => isCurrent = isCurrent && currentRouteName.contains(p));
      }

      return isCurrent;
    }catch(e) {
      print(e);
      return false;
    }
  }
}