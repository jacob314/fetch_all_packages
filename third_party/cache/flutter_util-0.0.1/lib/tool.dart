import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_util/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Tool {
  static get radix => null;

  ///***********基本函数*************///

  static void log(p1, [p2, p3, p4, p5, p6, p7, p8, p9]) {
    if (Common.isDebug() || Common.forcePrint) {
      p1 != null ? print(p1) : '';
      p2 != null ? print(p2) : '';
      p3 != null ? print(p3) : '';
      p4 != null ? print(p4) : '';
      p5 != null ? print(p5) : '';
      p6 != null ? print(p6) : '';
      p7 != null ? print(p7) : '';
      p8 != null ? print(p8) : '';
      p9 != null ? print(p9) : '';
    }
  }

  static bool empty(value) {
    if (value != null) {
      if (value is String) {
        return value == '';
      } else if (value is Map) {
        return value.length == 0;
      } else if (value is List) {
        return value.length == 0;
      } else if (value is num) {
        return parseInt(value) == 0;
      } else if (value == false) {
        return true;
      }
      return false;
    } else {
      return true;
    }
  }

  static bool maybeEmpty(value) {
    if (value == ' ' || value == 'small' || value == 'item') {
      return true;
    }
    return false;
  }

  static bool notEmpty(value) {
    return !empty(value);
  }

  static int parseInt(var size) {
    return parseDouble(size, 0.0).toInt();
  }

  static double parseDouble(var size, double initSize) {
    return size is double
        ? size
        : size is num
        ? size.toDouble()
        : size is String
        ? double.parse(size, (String source) {
      return initSize;
    })
        : initSize;
  }

  static BoxConstraints getBoxConstraintsWithValue(var value) {
    if (Tool.notEmpty(value) && value is Map) {
      return new BoxConstraints().copyWith(
        minHeight: Tool.notEmpty(value['minHeight'])
            ? Tool.parseDouble(value['minHeight'], 0.0)
            : null,
        maxHeight: Tool.notEmpty(value['maxHeight'])
            ? Tool.parseDouble(value['maxHeight'], 0.0)
            : null,
        maxWidth: Tool.notEmpty(value['maxWidth'])
            ? Tool.parseDouble(value['maxWidth'], 0.0)
            : null,
        minWidth: Tool.notEmpty(value['minWidth'])
            ? Tool.parseDouble(value['minWidth'], 0.0)
            : null,
      );
    }
    return null;
  }

  static BoxBorder getBoxBorderWithValue(var value, [color = 0]) {
    if (Tool.notEmpty(value) && value is Map) {
      return new Border.all(
          width: Tool.parseDouble(value['width'], 1.0),
          color: Tool.getColorWithValue(
              Tool.notEmpty(color) ? color : value['color']));
    }
    return null;
  }

  static Gradient getGradientWithValue(var value) {
    if (Tool.notEmpty(value) && value is Map) {
      Map gradient = value;
      //print(gradient);
      if (Tool.notEmpty(gradient['color']) && gradient['color'] is List) {
        //print(gradient['color']);
        List<int> colorData = List.from(gradient['color']);
        List<Color> colors = [];
        for (int index = 0; index < colorData.length; index++) {
          colors.add(Tool.getColorWithValue(colorData[index]));
        }
        return new LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        );
      }
    }
    return null;
  }

  static CrossAxisAlignment getCrossAxisAlignmentWithValue(var value) {
    if (value is String) {
      switch (value) {
        case 'start':
          {
            return CrossAxisAlignment.start;
          }
        case 'end':
          {
            return CrossAxisAlignment.end;
          }
        case 'center':
          {
            return CrossAxisAlignment.center;
          }
        case 'stretch':
          {
            return CrossAxisAlignment.stretch;
          }
        case 'baseline':
          {
            return CrossAxisAlignment.baseline;
          }
      }
    }
    return CrossAxisAlignment.start;
  }

  static MainAxisAlignment getMainAxisAlignmentWithValue(var value) {
    if (value is String) {
      switch (value) {
        case 'start':
          {
            return MainAxisAlignment.start;
          }
        case 'end':
          {
            return MainAxisAlignment.end;
          }
        case 'center':
          {
            return MainAxisAlignment.center;
          }
        case 'spaceBetween':
          {
            return MainAxisAlignment.spaceBetween;
          }
        case 'spaceAround':
          {
            return MainAxisAlignment.spaceAround;
          }
        case 'spaceEvenly':
          {
            return MainAxisAlignment.spaceEvenly;
          }
      }
    }
    return MainAxisAlignment.start;
  }

  static Alignment getAlignmentWithValue(var value) {
    if (value is String) {
      switch (value) {
        case 'topLeft':
          {
            return Alignment.topLeft;
          }
        case 'topCenter':
          {
            return Alignment.topCenter;
          }
        case 'topRight':
          {
            return Alignment.topRight;
          }
        case 'centerLeft':
          {
            return Alignment.centerLeft;
          }
        case 'centerRight':
          {
            return Alignment.centerRight;
          }
        case 'center':
          {
            return Alignment.center;
          }
        case 'bottomLeft':
          {
            return Alignment.bottomLeft;
          }
        case 'bottomCenter':
          {
            return Alignment.bottomCenter;
          }
        case 'bottomRight':
          {
            return Alignment.bottomRight;
          }
      }
    }

    if (Tool.notEmpty(value) && value is List<double>) {
      return new Alignment(value.first, value.last);
    }

    return null;
  }

  static TextAlign getTextAlignWithValue(var value) {
    if (value is String) {
      switch (value) {
        case 'left':
          {
            return TextAlign.left;
          }
        case 'right':
          {
            return TextAlign.right;
          }
        case 'center':
          {
            return TextAlign.center;
          }
        case 'justify':
          {
            return TextAlign.justify;
          }
        case 'start':
          {
            return TextAlign.start;
          }
        case 'end':
          {
            return TextAlign.end;
          }
      }
    }
    return TextAlign.left;
  }

  static TextOverflow getTextOverflowWithValue(var value) {
    if (value is String) {
      switch (value) {
        case 'fade':
          {
            return TextOverflow.fade;
          }
        case 'clip':
          {
            return TextOverflow.clip;
          }
        case 'ellipsis':
          {
            return TextOverflow.ellipsis;
          }
      }
    }
    return TextOverflow.ellipsis;
  }

  static BoxFit getBoxFitWithValue(var value) {
    if (value is String) {
      switch (value) {
        case 'cover':
          {
            return BoxFit.cover;
          }
        case 'fill':
          {
            return BoxFit.fill;
          }
        case 'contain':
          {
            return BoxFit.contain;
          }
        case 'fitWidth':
          {
            return BoxFit.fitWidth;
          }
        case 'fitHeight':
          {
            return BoxFit.fitHeight;
          }
        case 'none':
          {
            return BoxFit.none;
          }
        case 'scaleDown':
          {
            return BoxFit.scaleDown;
          }
      }
    }
    return BoxFit.none;
  }

  static EdgeInsets getEdgeInsetsWithValue(var value) {
    if (value is Map) {
      if (Tool.notEmpty(value['vertical']) ||
          Tool.notEmpty(value['horizontal'])) {
        return new EdgeInsets.symmetric(
          vertical: Tool.parseDouble(value['vertical'], 0.0),
          horizontal: Tool.parseDouble(value['horizontal'], 0.0),
        );
      } else {
        return new EdgeInsets.only(
          left: Tool.parseDouble(value['left'], 0.0),
          right: Tool.parseDouble(value['right'], 0.0),
          top: Tool.parseDouble(value['top'], 0.0),
          bottom: Tool.parseDouble(value['bottom'], 0.0),
        );
      }
    } else {
      return new EdgeInsets.all(Tool.parseDouble(value, 0.0));
    }
  }

  static Color getColorWithValue(var value) {
    if (value is String && value.contains('#', 0)) {
      value = value.replaceAll('#', '');
      return getColorWithIntValue(int.parse(value, radix: 16));
    }
    return getColorWithIntValue(parseInt(value));
  }

  static Color getColorWithIntValue(int intValue) {
    return new Color(intValue);
  }

  static double getAutoFontSize(double value) {
    return Common.isAndroid() ? value - 1 : value;
  }

  static FontWeight getFontWeightWithValue(var value) {
    if (value is String) {
      switch (value) {
        case 'normal':
          {
            return FontWeight.normal;
          }
        case 'bold':
          {
            return FontWeight.bold;
          }
      }
    }
    return getFontWeightWithIntValue(parseInt(value));
  }

  static FontWeight getFontWeightWithIntValue(int intValue) {
    if (intValue >= 0 && intValue < 9) {
      return FontWeight.values[intValue];
    } else {
      return FontWeight.normal;
    }
  }

/*时间格式化*/
  static getWeekDay(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        {
          return '星期一';
        }
      case DateTime.tuesday:
        {
          return '星期二';
        }
      case DateTime.wednesday:
        {
          return '星期三';
        }
      case DateTime.thursday:
        {
          return '星期四';
        }
      case DateTime.friday:
        {
          return '星期五';
        }
      case DateTime.saturday:
        {
          return '星期六';
        }
      case DateTime.sunday:
        {
          return '星期天';
        }
      default:
        {
          return '';
        }
    }
    return '';
  }

  /*倒计时剩余时间*/
  static countdownRestTimeFormDate(var _date) {
    int date = parseInt(_date);
    if (date == null || !(date is int) || date == 0) return '';

    if (date
        .toString()
        .length < 11) {
      date = date * 1000;
    }

    return date - DateTime
        .now()
        .millisecondsSinceEpoch;
  }


  /*时间格式化*/
  static transformDate(var _date) {
    int date = parseInt(_date);
    if (date == null || !(date is int) || date == 0) return '';

    if (date
        .toString()
        .length < 11) {
      date = date * 1000;
    }

    //int timeRemaining = new DateTime.now().millisecondsSinceEpoch - (date);
    final DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
    final DateTime nowDate = new DateTime.now();
    final DateTime toDayDate =
    new DateTime(nowDate.year, nowDate.month, nowDate.day);

    /* if (timeRemaining < 1000 * 60 * 3) {
      return "刚刚";
    } else if (timeRemaining < 1000 * 60 * 60) {
      return parseInt(timeRemaining / (1000 * 60)).toString() + "分钟前";
    } else if (nowDate.year == dateTime.year &&
        nowDate.month == dateTime.month &&
        nowDate.day == dateTime.day) {
      var formatter = new DateFormat('HH:mm');
      return formatter.format(dateTime);
    }
    var formatter = new DateFormat('yyyy/MM/dd');
    return formatter.format(dateTime);*/

    if (dateTime.isAfter(toDayDate)) {
      String time;
      if (dateTime.hour > 12) {
        time = '下午 ';
      } else {
        time = '上午 ';
      }
      var formatter = new DateFormat('hh:mm');
      return time + formatter.format(dateTime);
    } else if ((toDayDate.millisecondsSinceEpoch -
        dateTime.millisecondsSinceEpoch) <
        1000 * 60 * 60 * 24) {
      return '昨天';
    } else if ((toDayDate.millisecondsSinceEpoch -
        dateTime.millisecondsSinceEpoch) <
        1000 * 60 * 60 * 24 * 2) {
      return '前天';
    } else {
      var formatter = new DateFormat('yyyy/MM/dd');
      return formatter.format(dateTime);
    }
  }

  /*时间消息格式化*/
  static transformDateMessage(var _date) {
    int date = parseInt(_date);
    if (date == null || !(date is int) || date == 0) return '';

    if (date
        .toString()
        .length < 11) {
      date = date * 1000;
    }

    //int timeRemaining = new DateTime.now().millisecondsSinceEpoch - (date);
    final DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
    final DateTime nowDate = new DateTime.now();
    final DateTime toDayDate =
    new DateTime(nowDate.year, nowDate.month, nowDate.day);

    /* if (timeRemaining < 1000 * 60 * 3) {
      return "刚刚";
    } else if (timeRemaining < 1000 * 60 * 60) {
      return parseInt(timeRemaining / (1000 * 60)).toString() + "分钟前";
    } else if (nowDate.year == dateTime.year &&
        nowDate.month == dateTime.month &&
        nowDate.day == dateTime.day) {
      var formatter = new DateFormat('HH:mm');
      return formatter.format(dateTime);
    }
    var formatter = new DateFormat('yyyy/MM/dd');
    return formatter.format(dateTime);*/
    String time ='';
    if (dateTime.isAfter(toDayDate)) {
      time='';
    } else if ((toDayDate.millisecondsSinceEpoch -
        dateTime.millisecondsSinceEpoch) <
        1000 * 60 * 60 * 24) {
      time='昨天 ';
    } else if ((toDayDate.millisecondsSinceEpoch -
        dateTime.millisecondsSinceEpoch) <
        1000 * 60 * 60 * 24 * 2) {
      time='前天 ';
    } else {
      var formatter = new DateFormat('yyyy年MM月dd日');
      time= formatter.format(dateTime)+' ';
    }

    if (dateTime.hour > 12) {
      time = time+'下午';
    } else {
      time = time+'上午';
    }
    var formatter = new DateFormat('hh:mm');
    return time + formatter.format(dateTime);
  }

  static transformDateAt(var date, [newPattern = 'yyyy.MM.dd']) {
    DateTime dateTime;
    if (date is DateTime) {
      dateTime = date;
    } else {
      date = parseInt(date);
      if (date == null || !(date is int) || date == 0) return '';
      dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
    }

    var formatter = new DateFormat(newPattern);
    return formatter.format(dateTime);
  }

  /*地址格式化*/
  static String getAddressMessage(Map address) {
    if (Tool.empty(address)) {
      return '';
    }

    String text = '';
    if (Tool.notEmpty(address['province'])) {
      text = text + address['province'] + ' ';
    }
    if (Tool.notEmpty(address['city'])) {
      text = text + address['city'] + ' ';
    }
    if (Tool.notEmpty(address['district'])) {
      text = text + address['district'] + ' ';
    }
    return text;
  }

  static String getAddressText(Map address) {
    String text = '';
    if (Tool.notEmpty(address['remark'])) {
      text = text + '(' + address['remark'] + ') ';
    }
    text = text + getAddressMessage(address);
    return text;
  }

  static String getDayStyle() {
    DateTime date = new DateTime.now();
    if (date.hour >= 6 && date.hour < 11) {
      return 'morning';
    } else if (date.hour >= 11 && date.hour < 14) {
      return 'nooning';
    } else if (date.hour >= 14 && date.hour < 18) {
      return 'afternoon';
    } else if (date.hour >= 18 || date.hour < 6) {
      return 'evening';
    }
    return 'morning';
  }

  /*合并多层Map*/
  static Map mergeMap(Map map, var otherMap) {
    Map _map = {};
    if (map != null) {
      _map.addAll(map);
    }
    if (otherMap != null && otherMap is Map) {
      otherMap.forEach((key, value) {
        if (_map.containsKey(key)) {
          if (value is Map && _map[key] is Map) {
            Map _mergeMap = mergeMap(_map[key], value);
            _map.addAll({key: _mergeMap});
          } else {
            _map.addAll({key: value});
          }
        } else {
          _map.addAll({key: value});
        }
      });
    }

    return _map;
  }

  static String mergeUrl(String url, Map otherMap) {
    String _url = url;
    String _parameter = '';
    if (Tool.notEmpty(otherMap)) {
      otherMap.forEach((key, value) {
        if (!(value is int || value is double || value is String)) {
          value = json.encode(value);
        }
        _parameter += "$key=$value&";
      });
    }

    if (_parameter != '') {
      _parameter = _parameter.substring(0, _parameter.length - 1);

      if (_url.contains('?')) {
        _url = "$_url&$_parameter";
      } else {
        _url = "$_url?$_parameter";
      }
    }

    return _url;
  }

  ///***********算法函数*************///

  /*快速排序*/
  List quickSort(List arr) {
    //如果数组<=1,则直接返回
    if (arr.length <= 1) {
      return arr;
    }
    int pivotIndex = (arr.length ~/ 2).toInt();
    int pivot = arr.removeAt(pivotIndex);
    //定义左右数组
    List left = [];
    List right = [];

    //比基准小的放在left，比基准大的放在right
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] <= pivot) {
        left.add(arr[i]);
      } else {
        right.add(arr[i]);
      }
    }
    //递归
    return quickSort(left)
      ..add(pivot)
      ..addAll(quickSort(right));
  }

  ///***********数据处理函数*************///

  static Size getAppointmentBannerSizeWithValue(var value) {
    String message = getSVBannerMessageWithValue(value);
    if (empty(message)) {
      return const Size(0.0, 0.0);
    } else if (maybeEmpty(message)) {
      return const Size(9.0, 9.0);
    } else if (notEmpty(message) && message.length == 3) {
      return const Size(28.0, 20.0);
    } else {
      return const Size(20.0, 20.0);
    }
  }

  static Size getSVBannerSizeWithValue(var value) {
    String message = getSVBannerMessageWithValue(value);
    if (empty(message)) {
      return const Size(0.0, 0.0);
    } else if (maybeEmpty(message)) {
      return const Size(9.0, 9.0);
    } else if (notEmpty(message) && message.length == 3) {
      return const Size(28.0, 20.0);
    } else {
      return const Size(20.0, 20.0);
    }
  }

  static Size getSVBannerSizeWithMessage(var value) {
    String message = getSVBannerMessageWithValue(value);
    if (empty(message)) {
      return const Size(0.0, 0.0);
    } else if (message.length <= 2) {
      return const Size(26.0, 18.0);
    } else {
      return const Size(32.0, 18.0);
    }
  }

  static String getSVBannerMessageWithValue(var value) {
    String message = '';
    if (value is String) {
      message = value;
    }

    if (value is num) {
      int index = parseInt(value);
      if (index > 0 && index < 100) {
        message = index.toString();
      } else if (index >= 100) {
        message = '99+';
      }
    }

    //角标本字不多于3个
    if (message.length > 3) {
      message = message.substring(0, 3);
    }

    return message;
  }


  static List<Map> sortList(List<Map> datas) {
    //冒泡排序
    for (int i = 0; i < datas.length; i++) {
      for (int j = i; j < datas.length; j++) {
        Map iMap = datas[i];
        Map jMap = datas[j];
        if (parseInt(iMap['timestamp']) < parseInt(jMap['timestamp'])) {
          datas[i] = jMap;
          datas[j] = iMap;
        }
      }
    }
    return datas;
  }

  static List<String> getUserIdList(List<Map> datas) {
    Map userIdMap = {};
    datas.forEach((Map item) {
      if (notEmpty(item['peerId']) && item['peerId'] is String) {
        userIdMap[item['peerId']] = '';
      }
    });
    return userIdMap.keys.toList().cast<String>();
  }

  static List<Map> handleNoticeData(List<Map> datas, List<Map> userIds) {
    return datas
        .map((Map item) {
      if (notEmpty(item['peerId']) && item['peerId'] is String) {
        userIds.forEach((Map userInfo) {
          if (item['peerId'] == userInfo['id']) {
            item['name'] = userInfo['name'];
            item['avatar'] = userInfo['avatar'];
          }
        });
      }
      return item;
    })
        .toList()
        .cast<Map>();
  }

  static List getListVideo(Map content) {
    if (content == null) {
      return null;
    }
    List listVideo = content['listVideo'];
    listVideo = listVideo.map((item) {
      Map row = {
        "title": item['title'] ?? '',
        "avatar": item['thumbnail'] ?? '',
        "videoId": item['videoId'] ?? '',
        "partnerId": item['partnerId'] ?? '',
        "maxProgress": item['maxProgress'] ?? 0,
        "token": item['token'] ?? '',
      };
      return row;
    }).toList();

    return listVideo;
  }



  /*简单底部弹出选择框*/
  static showBottomSelectedView({@required BuildContext context,
    @required List values,
    bool hasResetButton: false,
    @required ValueChanged<Map> callback}) {
    showModalBottomSheet<Map>(
        context: context,
        builder: (BuildContext context) {
          return new GestureDetector(
            onTap: () {},
            child: new Container(
              child: new ListView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 40.0),
                  children: []
                    ..add(hasResetButton
                        ? new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new FlatButton(
                            onPressed: () {
                              Navigator.pop(context, {'action': 'reset'});
                            },
                            child: new Text('重置',
                                style: const TextStyle(color: Colors.red))))
                        : new Container())
                    ..addAll(values.map((item) {
                      return new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new FlatButton(
                              onPressed: () {
                                Navigator.pop(context, {
                                  'action': 'select',
                                  'item': item,
                                });
                              },
                              child: new Text(item['name'] ?? '')));
                    }).toList())),
            ),
          );
        }).then((data) {
      if (data != null && data is Map) {
        callback(data);
      } else {
        callback({'action': 'cancel'});
      }
    });
  }

  static Widget renderWidgetWithData(Map data) {
    if (data != null) {
      return renderWidgetWithType(data['type'], data['params']);
    }
    return null;
  }

  static Widget renderWidgetWithType(String type, Map params) {
    switch (type) {
      case 'container':
        {
          return new Container(
            child: renderWidgetWithData(params['child']),
          );
        }
      case 'text':
        {
          return new Text(params['text']);
        }
      case 'dropdown':
        {}
    }
    return null;
  }

  ///*********需要单独分类的函数********///

  static List getDataValueWithSelect(List data, List<int> select) {
    List value = [];
    if (notEmpty(select) && notEmpty(data)) {
      for (int index = 0; index < select.length; index++) {
        int i = select[index];
        if (data.length + 1 > i) {
          if (notEmpty(data[i]['value'])) {
            value.add(data[i]['value']);
          }
        }
      }
    }
    return value;
  }

  static String urlMargeList(String url, [List<Map> data = const []]) {
    data.forEach((item) {
      url = urlMarge(url, item);
    });
    return url;
  }

  static String urlMarge(String url, [Map<String, dynamic> data = const {}]) {
    String query = '';

    data.forEach((key, value) {
      if (!(value is int || value is double || value is String)) {
        value = json.encode(value);
      }
      query += "$key=$value&";
    });

    if (query != '') {
      query = query.substring(0, query.length - 1);
      if (!url.contains('?')) {
        url = "$url?$query";
      } else {
        url = "$url&$query";
      }
    }
    return url;
  }

}
