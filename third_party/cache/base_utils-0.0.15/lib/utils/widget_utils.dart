import 'dart:typed_data';

import 'package:base_utils/model/device.dart';
import 'package:base_utils/native_methods.dart';
import 'package:base_utils/ui/res/colors.dart';
import 'package:base_utils/ui/res/dimens.dart';
import 'package:base_utils/ui/scaless_text.dart';
import 'package:base_utils/utils/logging_utils.dart';
import 'package:base_utils/utils/string_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';

/*
trong scaffold đã có tính height của status bar rồi, chính vì lý do trường hợp không nằm trong scaffold mới phải tính height của status bar.
 */
Widget buildAppBar(
  BuildContext context, {
  String title,
  Widget titleWidget,
  String shareUrl,
  Function onExit,
  bool inScaffold = false,
  bool hasBack = true,
  BoxDecoration decoration,
  double elevation = AssetsDimen.defaultElevation,
  List<Widget> actions,
      Widget backButton,
      bool centerTitle
}) {
  var _theme = Theme.of(context);
  Widget w = Container(
    decoration: decoration,
    child: AppBar(
      elevation: 0.0,
      primary: false,
      title: titleWidget ?? buildAppBarTitle(context, title),
      leading:
          hasBack == true ? ( backButton ?? buildBackButton(context, onExit: onExit) ): null,
      automaticallyImplyLeading: hasBack == true ? true : false,
      centerTitle: centerTitle ?? (_theme.platform == TargetPlatform.iOS),
      actions: actions ?? buildAppBarActions(context, {'share': shareUrl}),
      backgroundColor: decoration != null ? Colors.transparent : null,
    ),
  );
  if (inScaffold) {
    return PreferredSize(
      preferredSize: Size(
        double.infinity,
        getAppBarHeight(context, inScaffold: inScaffold),
      ),
      child: Material(
        elevation: decoration != null ? 0.0 : elevation,
        color: decoration != null ? Colors.transparent : null,
        child: Container(
          padding: EdgeInsets.only(top: getStatusBarHeight(context)),
          decoration: decoration,
          color: decoration != null
              ? null
              : (_theme.platform == TargetPlatform.iOS
                  ? _theme.primaryColor
                  : _theme.primaryColorDark),
          child: w,
        ),
      ),
    );
  } else {
    return Material(
      elevation: decoration != null ? 0.0 : elevation,
      color: decoration != null ? Colors.transparent : null,
      child: Container(
        padding: EdgeInsets.only(top: getStatusBarHeight(context)),
        decoration: decoration,
        color: decoration != null
            ? null
            : (_theme.platform == TargetPlatform.iOS
                ? _theme.primaryColor
                : _theme.primaryColorDark),
        width: double.infinity,
        height: getAppBarHeight(context, inScaffold: inScaffold),
        child: w,
      ),
    );
  }
}

double getStatusBarHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

Widget buildAppBarTitle(BuildContext context, String title) {
  return ScalelessText(
    capitalize(title),
    style: Theme.of(context).platform == TargetPlatform.iOS
        ? TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          )
        : null,
  );
}

List<Widget> buildAppBarActions(
    BuildContext context, Map<String, dynamic> actions,
    {BoxDecoration actionDecoration}) {
  if (actions != null && actions.length > 0) {
    var widgets = List<Widget>();
    if (actions['share'] != null)
      widgets.add(buildAction(
        decoration: actionDecoration,
        icon: Icon(Icons.share),
        onPressed: () {
          //FIXME xử lý cho event temlate.
//            EventDetailPage.signalNewPageOpened(context);
          actionShareSendo(
            shareUrl: actions['share'],
          );
        },
      ));
    return widgets.isNotEmpty ? widgets : null;
  } else
    return null;
}

Widget buildAppBarTrans(BuildContext context,
    {String title,
    Widget titleWidget,
    String shareUrl,
    Function onExit,
      bool centerTitle,
    bool inScaffold = false, List<Widget> actions}) {
  final ThemeData _theme = Theme.of(context);
  final circleBackground = BoxDecoration(
      color: AssetsColor.transAppBarButtonBackground, shape: BoxShape.circle);
  Widget w = AppBar(
    primary: false,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    centerTitle:  centerTitle ?? (_theme.platform == TargetPlatform.iOS),
    leading: Container(
      child: buildBackButton(context, onExit: onExit),
      decoration: circleBackground,
    ),
    actions: actions ?? buildAppBarActions(context, {'share': shareUrl},
        actionDecoration: circleBackground),
  );

  if (inScaffold) {
    return PreferredSize(
        preferredSize: Size(
          double.infinity,
          getAppBarHeight(context, inScaffold: inScaffold),
        ),
        child: Container(
          padding: EdgeInsets.only(top: getStatusBarHeight(context)),
          child: w,
        ));
  } else {
    return _theme.platform == TargetPlatform.android
        ? Column(
            children: <Widget>[
              Container(
                height: getStatusBarHeight(context),
                width: double.infinity,
                color: _theme.primaryColorDark,
              ),
              w,
            ],
          )
        : Container(
            padding: EdgeInsets.only(top: getStatusBarHeight(context)),
            width: double.infinity,
            height: getAppBarHeight(context, inScaffold: inScaffold),
            child: w,
          );
  }
}

double getAppBarHeight(BuildContext context, {bool inScaffold = false}) {
  return (Theme.of(context).platform == TargetPlatform.iOS
          ? AssetsDimen.appBarHeightIOS
          : AssetsDimen.appBarHeightAndroid) +
      (inScaffold ? 0 : getStatusBarHeight(context));
}

EdgeInsets buildStatusBarPadding(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.android
      ? EdgeInsets.only(top: getStatusBarHeight(context))
      : null;
}

/*
0: small, 1: normal, 2: large
 */
const DEVICE_SIZE_SMALL = 0;
const DEVICE_SIZE_NORMAL = 1;
const DEVICE_SIZE_LARGE = 2;

int getDeviceSizeType(BuildContext context) {
  var width = MediaQuery.of(context).size.width;
//  var height = MediaQuery.of(context).size.height;
  if (width <= 330) {
    return DEVICE_SIZE_SMALL;
  } else if (width <= 360) {
    return DEVICE_SIZE_NORMAL;
  } else {
    return DEVICE_SIZE_LARGE;
  }
}

double convertToPixel(double dp) {
  return dp * 0.393701;
}

double convertToDp(int px) {
  return px / 0.393701;
}

void popDialog(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop('dialog');
  }
}

Widget buildBackButton(BuildContext context, {Function onExit, double size, Color color}) {
  return IconButton(
    iconSize: size ?? 24,
      color: color,
      icon: Icon(Theme.of(context).platform == TargetPlatform.iOS
          ? Icons.arrow_back_ios
          : Icons.arrow_back),
      onPressed: () {
        backOrExit(context, onExit: onExit);
      });
}

void backOrExit(BuildContext context, {Function onExit}) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else if (onExit != null) {
    onExit();
  } else {
    SystemNavigator.pop();
  }
}

bool get isDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<DeviceInfo> getDeviceInfo() async {
  DeviceInfo di = DeviceInfo();
  DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo;
  try {
    androidInfo = await deviceInfo.androidInfo;
  } catch (e) {
    log('getDeviceInfo: $e');
  }
  if (androidInfo != null) {
    log('getDeviceInfo: $androidInfo');
    di.udid = await actionGetUDID();
    di.model = androidInfo.model;
    di.brand = androidInfo.brand;
    di.os = "Android";
    di.osVersion = androidInfo.version.release;
  } else {
    try {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log('getDeviceInfo: $iosInfo');
      di.udid = iosInfo.identifierForVendor;
      di.model = iosInfo.model;
      di.brand = "Apple";
      di.os = "iOS";
      di.osVersion = iosInfo.systemVersion;
    } catch (e) {
      log('getDeviceInfo: $e');
    }
  }
  log('getDeviceInfo: finalInfo=${di.toJson()}');
  return di;
}

ImageProvider buildNetworkImage(
  String url, {
  double scale = 1.0,
  Map<String, String> header,
  bool useDiskCache = false,
  Function loadedCallback,
  Function loadFailedCallback,
  Uint8List fallbackImage,
}) {
  return AdvancedNetworkImage(
    url,
    scale: scale,
    fallbackImage: fallbackImage,
    header: header,
    loadedCallback: loadedCallback,
    loadFailedCallback: loadFailedCallback,
    useDiskCache: useDiskCache,
    timeoutDuration: Duration(seconds: 30),
    retryLimit: 10,
    retryDuration: Duration(milliseconds: 2800),
  );
}

int change(int input, int output, double percent) {
  int delta = output - input;
  return input + (delta * percent).round();
}

/**
 * scale from iPhone X
 */
double scaleHeight(BuildContext context, int value) {
  return (value / 812) * MediaQuery.of(context).size.height;
}

/**
 * scale from iPhone X
 */
double scaleWidth(BuildContext context, int value) {
  return (value / 375) * MediaQuery.of(context).size.width;
}

Widget buildAction({
  Decoration decoration,
  Widget icon,
  Function onPressed,
}) {
  return Container(
    decoration: decoration,
    margin: EdgeInsets.only(right: 4.0),
    child: IconButton(
      icon: icon,
      onPressed: onPressed,
    ),
  );
}

buildRaisedButton({Widget child, Function onPressed}) {
  return RaisedButton(
    onPressed: onPressed,
    color: Colors.transparent,
    elevation: 0.0,
    highlightColor: Colors.transparent,
//      splashColor: Colors.transparent,
    highlightElevation: 0.0,
    disabledColor: Colors.transparent,
    child: child,
  );
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

bool isSmallDevice(BuildContext context) {
  return MediaQuery.of(context).size.height < 600;
}
