import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/base/base_view_contract.dart';
import 'package:icetea_studio_core/ui/base/base_view_model.dart';
import 'package:icetea_studio_core/ui/widgets/progress_indicators/view_loading.dart';

abstract class BaseState<T extends StatefulWidget, V extends IBaseVM> extends State<T> implements IBaseViewContract<V> {
  V _vm;

  V get model => _vm;

  void set model(V vm) => _vm = vm;

  @override
  Widget build(BuildContext context) {
    return new Center();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void onNetworkTimeout() {
    ViewLoading.of(context).stopLoading();
    /*ToastUtils.showToast(Strings
        .of(context)
        .common_mes_networkTooLow);*/
  }

  @override
  void onUnAuthenticated() {
    ViewLoading.of(context).stopLoading();
//    Navigator.of(context).pushReplacementNamed(RouteNames.LOGIN);
  }

  @override
  void onNotAuthorized() {
    ViewLoading.of(context).stopLoading();
   /* ToastUtils.showToast(Strings
        .of(context)
        .common_mes_permissionDeny);*/
  }

  @override
  void onAuthInvalid() {
    ViewLoading.of(context).stopLoading();
//    Navigator.of(context).pushReplacementNamed(RouteNames.LOGIN);
  }

  viewUserProfile(String userId){
//    NavigatorUtil.push(context, RouteNames.VIEW_PROFILE, {"userId": userId});
  }
}