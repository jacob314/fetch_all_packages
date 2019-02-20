import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets innerPadding;
  final List<Widget> children;

  const CustomCard({
    this.padding = const EdgeInsets.all(10.0),
    this.innerPadding = const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 10.0,
    ),
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        shadowColor: Colors.grey,
        elevation: 3.0,
        child: Padding(
          padding: innerPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );  }
}

