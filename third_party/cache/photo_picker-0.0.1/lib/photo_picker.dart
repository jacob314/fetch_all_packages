import 'dart:async';

import 'package:flutter/services.dart';

class PhotoPicker {
  static const MethodChannel _channel = const MethodChannel('photo_picker');

  /// 从相册选择照片
  /// 返回中，t 为缩略图，固定为 300*300 大小 fill 方式剪裁；i 为大图最大 2048*2048 大小。
  /// 参数{ "limit": 3,"cameraRollFirst": true, "mode": "fit"}
  /// `limit` 为最大选择张数，0为不限制
  /// `cameraRollFirst` 是否默认显示用户相册
  /// `mode` 剪裁方式可选为 `fit`/`fill`
  static Future<List> pickPhoto(args) async {
    final List list = await _channel.invokeMethod('photoPicker', args);
    return list;
  }

  /// 拍照
  /// 返回中，t 为缩略图，固定为 300*300 大小 fill 方式剪裁；i 为大图最大 2048*2048 大小。
  /// 参数 { "edit": false }
  /// `edit` 是否可编辑
  static Future<List> camera(args) async {
    final List list = await _channel.invokeMethod('camera', args);
    return list;
  }
}
