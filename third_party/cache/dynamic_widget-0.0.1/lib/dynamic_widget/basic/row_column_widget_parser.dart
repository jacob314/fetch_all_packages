

import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class RowWidgetParser extends WidgetParser{
  @override
  bool forWidget(String widgetName) {
    return "Row" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map) {
    return Row(
      crossAxisAlignment: map.containsKey('crossAxisAlignment') ? parseCrossAxisAlignment(map['crossAxisAlignment']) : CrossAxisAlignment.center,
      mainAxisAlignment: map.containsKey('mainAxisAlignment') ? parseMainAxisAlignment(map['mainAxisAlignment']) : MainAxisAlignment.start,
      mainAxisSize: map.containsKey('mainAxisSize') ? parseMainAxisSize(map['mainAxisSize']) : MainAxisSize.max,
      textBaseline: map.containsKey('textBaseline') ? parseTextBaseline(map['textBaseline']) : null,
      textDirection: map.containsKey('textDirection') ? parseTextDirection(map['textDirection']) : null,
      verticalDirection: map.containsKey('verticalDirection') ? parseVerticalDirection(map['verticalDirection']) : VerticalDirection.down,
      children: DynamicWidgetBuilder().buildWidgets(map['children']),
    );
  }

}

class ColumnWidgetParser extends WidgetParser{
  @override
  bool forWidget(String widgetName) {
    // TODO: implement forWidget
    return null;
  }

  @override
  Widget parse(Map<String, dynamic> map) {
    // TODO: implement parse
    return null;
  }

}