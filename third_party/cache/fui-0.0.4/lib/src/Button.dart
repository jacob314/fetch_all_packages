import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
        child: new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Text(
        'Hello, ! How are you?',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ));
  }
}
