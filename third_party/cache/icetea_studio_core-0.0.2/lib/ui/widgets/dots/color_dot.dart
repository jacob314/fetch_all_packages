import 'package:flutter/material.dart';

class ColorDot extends StatelessWidget {
  final Color _color;
  final double _size;

  ColorDot(this._color, this._size, {Key key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration:
      BoxDecoration(
          color: _color,
          shape: BoxShape.circle
      ),
    );
  }
}