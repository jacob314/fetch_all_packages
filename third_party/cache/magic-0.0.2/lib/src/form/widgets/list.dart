import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FormList extends StatelessWidget {
  final List<FormItem> items;

  FormList({@required this.items});

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: this.items
    );
  }
}

class FormItem extends StatelessWidget {
  final Widget input;

  FormItem({@required this.input});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: input,
    );
  }
}