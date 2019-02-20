import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_aware/src/platform_aware_app_bar.dart';
import 'package:platform_aware/src/platform_aware_widget.dart';

class PlatformAwareTabItem {
  final String text;
  final IconData icon;

  PlatformAwareTabItem({@required this.text, @required this.icon});
}

class PlatformAwareScaffold extends PlatformAwareWidget {
  final Widget body;
  final Widget leading;
  final Widget title;
  final Iterable<Widget> actions;
  final Iterable<PlatformAwareTabItem> tabs;
  final IndexedWidgetBuilder tabViewBuilder;

  PlatformAwareScaffold(
      {@required this.title,
      this.actions,
      this.body,
      this.tabs,
      this.tabViewBuilder,
      this.leading}) {
    assert((tabs == null) == (tabViewBuilder == null));
  }

  @override
  Widget buildAndroid(BuildContext context) => tabs == null
      ? _buildAndroidScaffold(context)
      : new DefaultTabController(
          length: tabs.length, child: _buildAndroidScaffold(context));

  Widget _buildAndroidScaffold(BuildContext context) => new Scaffold(
      body: tabs == null
          ? body
          : new TabBarView(
              children: new Iterable.generate(tabs.length,
                  (int index) => tabViewBuilder(context, index)).toList()),
      appBar: buildAndroidAppBar(context,
          leading: leading,
          title: title,
          actions: actions,
          bottom: tabs == null
              ? null
              : new TabBar(
                  tabs: tabs
                      .map((PlatformAwareTabItem item) => new Tab(
                            text: item.text,
                            icon: new Icon(item.icon),
                          ))
                      .toList())));

  Widget _buildCupertinoBody(BuildContext context) => tabs == null
      ? body
      : new CupertinoTabScaffold(
          tabBar: new CupertinoTabBar(
              items: tabs
                  .map((PlatformAwareTabItem item) =>
                      new BottomNavigationBarItem(
                          icon: new Icon(item.icon),
                          title: new Text(item.text)))
                  .toList()),
          tabBuilder: tabViewBuilder);

  @override
  Widget buildCupertino(BuildContext context) => new CupertinoPageScaffold(
      child: _buildCupertinoBody(context),
      navigationBar: buildCupertinoAppBar(context,
          title: title, actions: actions, leading: leading));
}
