
import 'package:flutter/material.dart';

abstract class  IBaseViewContract<T> {
  T model;

  bool get mounted;

  void setState(VoidCallback callback);

  /// This is handler when user failed authentication
  /// because of wrong password, username, ...
  void onUnAuthenticated();

  /// This is handler when user doesn't have permission to do an action
  void onNotAuthorized();

  /// This is handler when the current token is invalid, expired
  void onAuthInvalid();

  ///Network request timeout
  void onNetworkTimeout();
}