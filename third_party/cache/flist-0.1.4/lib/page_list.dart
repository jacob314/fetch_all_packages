
import 'package:flutter/material.dart';
import 'list_builder.dart';

export 'list_builder.dart';
export 'paginator/paginator.dart';
export 'paginator/length_aware_paginator.dart';

class PageList extends StatefulWidget {
  final ListBuilder builder;

  PageList({Key key, this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new PageListState();
}

class PageListState extends State<PageList> {

  @override
  void initState() {
    super.initState();
    widget.builder.loadData().then((items) => setState(() => {}));
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.onBuildList(context);
  }
}