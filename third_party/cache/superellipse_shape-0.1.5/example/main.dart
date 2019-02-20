import 'package:flutter/material.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SuperellipseCard(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text('This is a nice, rounded card.'),
            ), // Padding
          ), // SuperellipseCard
        ), // Center
      ), // Scaffold
    ); // MaterialApp
  }
}

class SuperellipseCard extends StatelessWidget {
  SuperellipseCard({
    this.color,
    this.child,
    this.elevation,
  });

  final Color color;
  final Widget child;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: SuperellipseShape(
        borderRadius: BorderRadius.circular(28.0),
      ), // SuperellipseShape
      color: color ?? Colors.white,
      shadowColor: color ?? Colors.black38,
      elevation: elevation ?? 1.0,
      child: child,
    ); // Material
  }
}
