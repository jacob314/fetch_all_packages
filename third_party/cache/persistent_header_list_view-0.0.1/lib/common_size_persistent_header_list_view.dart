import 'package:flutter/widgets.dart';
import 'package:persistent_header_list_view/persistent_header_list_view.dart';

class CommonSizePersistentHeaderListView extends StatelessWidget {
  final ScrollController controller;
  final double headerHeight;
  final double itemHeight;
  final HeaderWidgetBuilder headerWidgetBuilder;
  final ItemWidgetBuilder itemWidgetBuilder;
  final int headerCount;

  CommonSizePersistentHeaderListView({
    this.controller,
    this.headerHeight,
    this.headerWidgetBuilder,
    this.itemHeight,
    this.itemWidgetBuilder,
    this.headerCount,
  })  : assert(headerHeight >= 0),
        assert(itemHeight >= 0),
        assert(headerCount >= 0),
        assert(headerWidgetBuilder != null),
        assert(itemWidgetBuilder != null);

  @override
  Widget build(BuildContext context) {
    return new PersistentHeaderListView(
      controller: controller,
      headerCount: headerCount,
      headerWidgetBuilder: (context, headerIndex) => new _PreferSizeWidget(
          headerWidgetBuilder(context, headerIndex), headerHeight),
      itemWidgetBuilder: (context, headerIndex) =>
          itemWidgetBuilder(context, headerIndex)
              .map((widget) => new _PreferSizeWidget(widget, itemHeight))
              .toList(),
    );
  }
}

typedef Widget HeaderWidgetBuilder(BuildContext context, int headerIndex);
typedef List<Widget> ItemWidgetBuilder(BuildContext context, int headerIndex);

class _PreferSizeWidget extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget child;

  _PreferSizeWidget(this.child, this.height);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      height: height,
      child: child,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(height);
}
