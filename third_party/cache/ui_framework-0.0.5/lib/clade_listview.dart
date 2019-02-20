library ui_framework;

import 'package:flutter/material.dart';
import 'package:ui_framework/common/atomic/custom_card/custom_card.dart';

/// A Custom Card
class CladeListView extends StatelessWidget {
  final List<CustomCard> listCards;

  CladeListView({this.listCards});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: listCards,
      )
    );
  }
}
