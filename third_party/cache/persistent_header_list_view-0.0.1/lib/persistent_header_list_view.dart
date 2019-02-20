library persistent_header_list_view;

import 'package:flutter/widgets.dart';

class PersistentHeaderListView extends StatelessWidget {
  final ScrollController controller;

  final HeaderWidgetBuilder headerWidgetBuilder;
  final ItemWidgetsBuilder itemWidgetBuilder;
  final int headerCount;

  PersistentHeaderListView({
    this.controller,
    this.headerWidgetBuilder,
    this.itemWidgetBuilder,
    this.headerCount,
  })  : assert(headerWidgetBuilder != null),
        assert(itemWidgetBuilder != null),
        assert(headerCount >= 0);

  @override
  Widget build(BuildContext context) {
    return new CustomScrollView(
      key: key,
      controller: controller,
      slivers: _buildSlivers(context),
    );
  }

  List<Widget> _buildSlivers(context) {
    var list = <Widget>[];
    for (int i = 0; i < headerCount; i++) {
      list.add(new SliverPersistentHeader(
          delegate: new ScrollDelegate(
              header: headerWidgetBuilder(context, i),
              items: itemWidgetBuilder(context, i))));
    }
    return list;
  }
}

typedef PreferredSizeWidget HeaderWidgetBuilder(
    BuildContext context, int headerIndex);
typedef List<PreferredSizeWidget> ItemWidgetsBuilder(
    BuildContext context, int headerIndex);

class ScrollDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget header;
  final List<PreferredSizeWidget> items;

  ScrollDelegate({this.header, this.items});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Stack(
      children: <Widget>[
        new OverflowBox(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: items,
          ),
          maxHeight: maxExtent,
          minHeight: minExtent,
          alignment: Alignment.bottomCenter,
        ),
        header
      ],
    );
  }

  @override
  double get maxExtent {
    var height = header.preferredSize.height;
    items.forEach((w) => height += w.preferredSize.height);
    return height;
  }

  @override
  double get minExtent => header.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) =>
      this != oldDelegate;
}
