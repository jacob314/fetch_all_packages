import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../picker/picker_item.dart';

typedef PickerSelectedCallback = void Function(
    Picker picker, int index, List<int> selecteds);
typedef PickerConfirmCallback = void Function(
    Picker picker, List<int> selecteds);

/// 底部弹出选择器
class Picker<T> {
  // data, pickerdata, adapter 必须设置其中一个
  Picker({
    this.data,
    this.pickerDataList,
    this.adapter,
    this.selectedList,
    this.height = 150.0,
    this.itemExtent = 28.0,
    this.columnPadding,
    this.textStyle,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.textAlign = TextAlign.start,
    this.title,
    this.cancelText = '取消',
    this.confirmText = '确认',
    this.backgroundColor = Colors.white,
    this.containerColor,
    this.headerColor,
    this.changeToFirst = false,
    this.hideHeader = false,
    this.columnFlex,
    this.onCancel,
    this.onSelect,
    this.onConfirm,
  });

  List<PickerItem<T>> data;
  List<int> selectedList;
  PickerAdapter adapter;
  final List pickerDataList;

  final VoidCallback onCancel;
  final PickerSelectedCallback onSelect;
  final PickerConfirmCallback onConfirm;

  final bool changeToFirst;

  final List<int> columnFlex;

  final Widget title;
  final String cancelText;
  final String confirmText;

  final double height, itemExtent;
  final TextStyle textStyle, cancelTextStyle, confirmTextStyle;
  final TextAlign textAlign;
  final EdgeInsetsGeometry columnPadding;
  final Color backgroundColor, headerColor, containerColor;
  final bool hideHeader;

  bool _parseDataOK = false;
  int _maxLevel = 1;

  Widget _widget;
  PickerWidgetState _state;

  static const double DefaultTextSize = 20.0;

  Widget get widget => _widget;

  PickerWidgetState get state => _state;

  /// 生成picker控件
  Widget makePicker([ThemeData themeData]) {
    _parseData();
    _widget = _PickerWidget(picker: this, themeData: themeData);
    return _widget;
  }

  /// 显示 picker
  void show(BuildContext context, [ThemeData themeData]) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return makePicker(themeData);
      },
    );
  }

  /// 显示模态 picker
  void showAsModal(BuildContext context, [ThemeData themeData]) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return makePicker(themeData);
      },
    );
  }

  void showAsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title,
          actions: [
            FlatButton(
              onPressed: onCancel,
              child: Text(cancelText ?? ''),
            ),
            FlatButton(
              onPressed: () {
                if (onConfirm != null) onConfirm(this, selectedList);
              },
              child: Text(confirmText ?? ''),
            ),
          ],
          content: makePicker(),
        );
      },
    );
  }

  /// 获取当前选择的值
  List<T> getSelectedValues() {
    return adapter.getSelectedValues() as List<T>;
  }

  _parseData() {
    if (_parseDataOK) return;
    if (adapter == null) {
      if (pickerDataList != null &&
          pickerDataList.length > 0 &&
          (data == null || data.length == 0)) {
        if (data == null) data = List<PickerItem<T>>();
        _parsePickerDataItem(pickerDataList, data);
      }
      adapter = PickerDataAdapter<T>(this);
    }

    _maxLevel = adapter.maxLevel;
    if (adapter.picker == null) adapter.picker = this;
    adapter.initSelects();

    _parseDataOK = true;
  }

  _parsePickerDataItem(List pickerDataList, List<PickerItem> data) {
    if (pickerDataList == null) return;
    for (int i = 0; i < pickerDataList.length; i++) {
      var item = pickerDataList[i];
      if (item is T) {
        data.add(PickerItem<T>(value: item));
      } else if (item is Map) {
        final Map map = item;
        if (map.length == 0) continue;

        List<T> _maplist = map.keys.toList();
        for (int j = 0; j < _maplist.length; j++) {
          var _o = map[_maplist[j]];
          if (_o is List && _o.length > 0) {
            List<PickerItem<T>> _children = List<PickerItem<T>>();
            //print('add: ${data.runtimeType.toString()}');
            data.add(PickerItem<T>(value: _maplist[j], children: _children));
            _parsePickerDataItem(_o, _children);
          }
        }
      } else if (T == String && !(item is List)) {
        String _v = item.toString();
        data.add(PickerItem<T>(value: _v as T));
      }
    }
  }
}

class _PickerWidget<T> extends StatefulWidget {
  final Picker<T> picker;
  final ThemeData themeData;

  _PickerWidget({Key key, @required this.picker, @required this.themeData})
      : super(key: key);

  @override
  PickerWidgetState createState() => PickerWidgetState<T>();
}

class PickerWidgetState<T> extends State<_PickerWidget> {
  ThemeData theme;
  final List<FixedExtentScrollController> scrollController = [];

  @override
  void initState() {
    super.initState();
    widget.picker._state = this;
    widget.picker.adapter.doShow();

    if (scrollController.length == 0) {
      for (int i = 0; i < widget.picker._maxLevel; i++)
        scrollController.add(
          FixedExtentScrollController(
              initialItem: widget.picker.selectedList[i]),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (widget.picker.hideHeader)
            ? SizedBox()
            : Container(
                child: Row(
                  children: _buildHeaderViews(),
                ),
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: theme.dividerColor, width: 0.5)),
                  color: widget.picker.headerColor == null
                      ? theme.bottomAppBarColor
                      : widget.picker.headerColor,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildViews(),
        ),
      ],
    );
  }

  List<Widget> _buildHeaderViews() {
    if (theme == null) theme = Theme.of(context);
    List<Widget> items = [];
    items.add(
      FlatButton(
        onPressed: () {
          if (widget.picker.onCancel != null) widget.picker.onCancel();
          Navigator.of(context).pop();
          widget.picker._widget = null;
        },
        child: Text(
          widget.picker.cancelText ?? '',
          overflow: TextOverflow.ellipsis,
          style: widget.picker.cancelTextStyle ??
              theme.textTheme.subhead.copyWith(color: Colors.black87),
        ),
      ),
    );
    items.add(
      Expanded(
        child: Container(
          alignment: Alignment.center,
          child: widget.picker.title == null
              ? widget.picker.title
              : DefaultTextStyle(
                  style: theme.textTheme.title,
                  child: widget.picker.title,
                ),
        ),
      ),
    );
    items.add(
      FlatButton(
        onPressed: () {
          if (widget.picker.onConfirm != null)
            widget.picker.onConfirm(widget.picker, widget.picker.selectedList);
          Navigator.of(context).pop();
          widget.picker._widget = null;
        },
        child: Text(
          widget.picker.confirmText ?? '',
          overflow: TextOverflow.ellipsis,
          style: widget.picker.confirmTextStyle ??
              theme.textTheme.subhead.copyWith(color: theme.primaryColor),
        ),
      ),
    );
    return items;
  }

  List<Widget> _buildViews() {
    if (theme == null) theme = Theme.of(context);

    List<Widget> items = [];

    PickerAdapter adapter = widget.picker.adapter;
    if (adapter != null) adapter.setColumn(-1);

    if (adapter != null && adapter.length > 0) {
      for (int i = 0; i < widget.picker._maxLevel; i++) {
        Widget view = Expanded(
          flex: adapter.getColumnFlex(i),
          child: Container(
            padding: widget.picker.columnPadding,
            height: widget.picker.height,
            decoration: BoxDecoration(
              border: widget.picker.hideHeader
                  ? null
                  : Border(
                      top: BorderSide(color: theme.dividerColor, width: 0.5)),
              color: widget.picker.containerColor == null
                  ? theme.dialogBackgroundColor
                  : widget.picker.containerColor,
            ),
            child: CupertinoPicker(
              backgroundColor: widget.picker.backgroundColor,
              scrollController: scrollController[i],
              itemExtent: widget.picker.itemExtent,
              onSelectedItemChanged: (int index) {
                setState(() {
                  widget.picker.selectedList[i] = index;
                  adapter.doSelect(i, index);
                  if (widget.picker.changeToFirst) {
                    for (int j = i + 1;
                        j < widget.picker.selectedList.length;
                        j++) {
                      widget.picker.selectedList[j] = 0;
                      scrollController[j].jumpTo(0.0);
                    }
                  }
                  if (widget.picker.onSelect != null)
                    widget.picker
                        .onSelect(widget.picker, i, widget.picker.selectedList);
                });
              },
              children: List<Widget>.generate(adapter.length, (int index) {
                return adapter.buildItem(index);
              }),
            ),
          ),
        );
        items.add(view);
        adapter.setColumn(i);
      }
    }
    return items;
  }
}

/// 选择器数据适配器
abstract class PickerAdapter<T> {
  Picker picker;

  int getLength();

  int getMaxLevel();

  String getText() {
    return getSelectedValues().toString();
  }

  void setColumn(int index);

  void initSelects();

  Widget buildItem(int index);

  List<T> getSelectedValues() {
    return <T>[];
  }

  void doShow() {}

  void doSelect(int column, int index) {}

  int getColumnFlex(int column) {
    if (picker.columnFlex != null && column < picker.columnFlex.length)
      return picker.columnFlex[column];
    return 1;
  }

  int get maxLevel => getMaxLevel();

  int get length => getLength();

  String get text => getText();

  @override
  String toString() {
    return getText();
  }

  /// 通知适配器数据改变
  void notifyDataChanged() {
    if (picker != null && picker.state != null) {
      picker.adapter.doShow();
      picker.adapter.initSelects();
      for (int j = 0; j < picker.selectedList.length; j++)
        picker.state.scrollController[j].jumpToItem(picker.selectedList[j]);
    }
  }
}

/// 数据适配器
class PickerDataAdapter<T> extends PickerAdapter<T> {
  List<PickerItem<dynamic>> _datas;
  int _maxLevel = -1;

  PickerDataAdapter(Picker picker) {
    super.picker = picker;
  }

  void setColumn(int index) {
    if (index < 0)
      _datas = picker.data;
    else {
      int select = picker.selectedList[index];
      if (_datas != null && _datas.length > select)
        _datas = _datas[select].children;
      else
        _datas = null;
    }
  }

  @override
  int getLength() {
    return _datas == null ? 0 : _datas.length;
  }

  @override
  getMaxLevel() {
    if (_maxLevel == -1) _checkPickerDataLevel(picker.data, 1);
    return _maxLevel;
  }

  @override
  Widget buildItem(int index) {
    final PickerItem item = _datas[index];
    if (item.text != null) {
      return item.text;
    }
    return Container(
      alignment: Alignment.center,
      child: item.text ??
          Text(
            item.value.toString(),
            style: picker.textStyle ??
                TextStyle(
                    color: Colors.black87, fontSize: Picker.DefaultTextSize),
            textAlign: picker.textAlign,
          ),
    );
  }

  @override
  void initSelects() {
    if (picker.selectedList == null || picker.selectedList.length == 0) {
      if (picker.selectedList == null) picker.selectedList = List<int>();
      for (int i = 0; i < _maxLevel; i++) picker.selectedList.add(0);
    }
  }

  @override
  List<T> getSelectedValues() {
    List<T> _items = [];
    if (picker.selectedList != null) {
      List<PickerItem<dynamic>> datas = picker.data;
      for (int i = 0; i < picker.selectedList.length; i++) {
        int j = picker.selectedList[i];
        if (j < 0 || j >= datas.length) break;
        _items.add(datas[j].value as T);
        datas = datas[j].children;
        if (datas == null || datas.length == 0) break;
      }
    }
    return _items;
  }

  _checkPickerDataLevel(List<PickerItem> data, int level) {
    if (data == null) return;
    for (int i = 0; i < data.length; i++) {
      if (data[i].children != null && data[i].children.length > 0)
        _checkPickerDataLevel(data[i].children, level + 1);
    }
    if (_maxLevel < level) _maxLevel = level;
  }
}

/// Picker DateTime Adapter Type
class PickerDateTimeType {
  static const int kMDY = 0; // m, d, y
  static const int kHM = 1; // hh, mm
  static const int kHMS = 2; // hh, mm, ss
  static const int kHM_AP = 3; // hh, mm, ap(AM/PM)
  static const int kMDYHM = 4; // m, d, y, hh, mm
  static const int kMDYHM_AP = 5; // m, d, y, hh, mm, AM/PM
  static const int kMDYHMS = 6; // m, d, y, hh, mm, ss

  static const int kYMD = 7; // y, m, d
  static const int kYMDHM = 8; // y, m, d, hh, mm
  static const int kYMDHMS = 9; // y, m, d, hh, mm, ss
  static const int kYMD_AP_HM = 10; // y, m, d, ap, hh, mm

  static const int kYM = 11; // y, m
}

class DateTimePickerAdapter extends PickerAdapter<DateTime> {
  final int type;
  final bool isNumberMonth;
  final List<String> months;
  final List<String> strAMPM;
  final int yearBegin, yearEnd;
  final String yearSuffix, monthSuffix, daySuffix;

  static const List<String> MonthsList_EN = const [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static const List<String> MonthsList_EN_L = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  DateTimePickerAdapter({
    Picker picker,
    this.type = 0,
    this.isNumberMonth = false,
    this.months = MonthsList_EN,
    this.strAMPM = const ["AM", "PM"],
    this.yearBegin = 1900,
    this.yearEnd = 2100,
    this.value,
    this.yearSuffix,
    this.monthSuffix,
    this.daySuffix,
  }) {
    super.picker = picker;
  }

  int _col = 0;
  int _col_ap = -1;

  DateTime value;

  static const List<List<int>> lengths = const [
    [12, 31, 0],
    [24, 60],
    [24, 60, 60],
    [12, 60, 2],
    [12, 31, 0, 24, 60],
    [12, 31, 0, 12, 60, 2],
    [12, 31, 0, 24, 60, 60],
    [0, 12, 31],
    [0, 12, 31, 24, 60],
    [0, 12, 31, 24, 60, 60],
    [0, 12, 31, 2, 12, 60],
    [0, 12],
  ];

  // year 0, month 1, day 2, hour 3, minute 4, sec 5, am/pm 6, hour-ap: 7
  static const List<List<int>> columnType = const [
    [1, 2, 0],
    [3, 4],
    [3, 4, 5],
    [7, 4, 6],
    [1, 2, 0, 3, 4],
    [1, 2, 0, 7, 4, 6],
    [1, 2, 0, 3, 4, 5],
    [0, 1, 2],
    [0, 1, 2, 3, 4],
    [0, 1, 2, 3, 4, 5],
    [0, 1, 2, 6, 7, 4],
    [0, 1],
  ];

  static const List<int> leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

  // 获取当前列的类型
  int getColumnType(int index) {
    List<int> items = columnType[type];
    if (index >= items.length) return -1;
    return items[index];
  }

  @override
  int getLength() {
    int v = lengths[type][_col];
    if (v == 0) return yearEnd - yearBegin;
    if (v == 31) return _calcDateCount(value.year, value.month);
    return v;
  }

  @override
  int getMaxLevel() {
    switch (type) {
      case 1:
        return 2; // hh, mm
      case 2:
        return 3; // hh, mm, ss
      case 3:
        return 3; // hh, mm, AM/PM
      case 4:
        return 5; // m, d, y, hh, mm
      case 5:
        return 6; // m, d, y, hh, mm, AM/PM
      case 6:
        return 6; // m, d, y, hh, mm, ss
      case 7:
        return 3; // y, m, d
      case 8:
        return 5; // y, m, d, hh, mm
      case 9:
        return 6; // y, m, d, hh, mm, ss
      case 10:
        return 6; // y, m, d, ap, hh, mm
      case 11:
        return 2; // y, m
      default:
        return 3; // m, d, y
    }
  }

  @override
  void setColumn(int index) {
    //print("setColumn index: $index");
    _col = index + 1;
    if (_col < 0) _col = 0;
  }

  @override
  void initSelects() {
    if (value == null) value = DateTime.now();
    _col_ap = _getAPColIndex();
    int _maxLevel = getMaxLevel();
    if (picker.selectedList == null || picker.selectedList.length == 0) {
      if (picker.selectedList == null) picker.selectedList = List<int>();
      for (int i = 0; i < _maxLevel; i++) picker.selectedList.add(0);
    }
  }

  @override
  Widget buildItem(int index) {
    String _text = "";
    int coltype = getColumnType(_col);
    switch (coltype) {
      case 0:
        _text = "${yearBegin + index}${_checkStr(yearSuffix)}";
        break;
      case 1:
        if (isNumberMonth) {
          _text = "${index + 1}${_checkStr(monthSuffix)}";
        } else {
          _text = "${months[index]}";
        }
        break;
      case 2:
        _text = "${index + 1}${_checkStr(daySuffix)}";
        break;
      case 3:
      case 4:
      case 5:
      case 7:
        _text = "${intToStr(index)}";
        break;
      case 6:
        _text = "${strAMPM[index]}";
        break;
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        _text,
        style: picker.textStyle ??
            TextStyle(color: Colors.black87, fontSize: Picker.DefaultTextSize),
        textAlign: picker.textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  @override
  String getText() {
    return value.toString();
  }

  @override
  int getColumnFlex(int column) {
    if (getColumnType(column) == 0) {
      return 3;
    }
    return 2;
  }

  @override
  void doShow() {
    for (int i = 0; i < getMaxLevel(); i++) {
      int coltype = getColumnType(i);
      switch (coltype) {
        case 0:
          picker.selectedList[i] = value.year - yearBegin;
          break;
        case 1:
          picker.selectedList[i] = value.month - 1;
          break;
        case 2:
          picker.selectedList[i] = value.day - 1;
          break;
        case 3:
          picker.selectedList[i] = value.hour;
          break;
        case 4:
          picker.selectedList[i] = value.minute;
          break;
        case 5:
          picker.selectedList[i] = value.second;
          break;
        case 6:
          picker.selectedList[i] = (value.hour >= 12) ? 1 : 0;
          break;
        case 7:
          picker.selectedList[i] =
              (value.hour >= 12) ? value.hour - 12 - 1 : value.hour - 1;
          break;
      }
    }
  }

  @override
  void doSelect(int column, int index) {
    int year, month, day, h, m, s;
    year = value.year;
    month = value.month;
    day = value.day;
    h = value.hour;
    m = value.minute;
    s = value.second;
    if (type != 2 && type != 6) s = 0;

    int coltype = getColumnType(column);
    switch (coltype) {
      case 0:
        year = yearBegin + index;
        break;
      case 1:
        month = index + 1;
        break;
      case 2:
        day = index + 1;
        break;
      case 3:
        h = index;
        break;
      case 4:
        m = index;
        break;
      case 5:
        s = index;
        break;
      case 6:
        if (_col_ap >= 0) {
          if (picker.selectedList[_col_ap] == 0) {
            if (h > 12) h = h - 12;
          } else {
            if (h < 12) h = h + 12;
          }
        }
        break;
      case 7:
        h = index;
        if (_col_ap >= 0 && picker.selectedList[_col_ap] == 1) h = h + 12;
        break;
    }
    int cday = _calcDateCount(year, month);
    if (day > cday) day = cday;
    value = DateTime(year, month, day, h, m, s);
  }

  int _getAPColIndex() {
    List<int> items = columnType[type];
    for (int i = 0; i < items.length; i++) {
      if (items[i] == 6) return i;
    }
    return -1;
  }

  int _calcDateCount(int year, int month) {
    if (leapYearMonths.contains(month)) {
      return 31;
    } else if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }

  String intToStr(int v) {
    if (v < 10) return "0$v";
    return "$v";
  }

  String _checkStr(String v) {
    if (v == null) return "";
    return v;
  }
}
