import 'package:flutter/material.dart';

class RitualsText extends StatelessWidget {
  RitualsText(this.text, {
    Key key,
    this.size
  }) : super(key: key);

  final String text;
  final RitualsTextSize size;

  @override
  Widget build(BuildContext context) {
    return _buildUi();
  }

  Text _buildUi() {
    return new Text(text,
      style: _style(),
    );
  }

  TextStyle _style() {
    return new TextStyle(
      fontSize: _size()
    );
  }

  double _size() {
    if (RitualsTextSize.small == size) {
      return 15.0;
    }

    if (RitualsTextSize.medium == size) {
      return 20.0;
    }

    if (RitualsTextSize.large == size) {
      return 25.0;
    }

    if (RitualsTextSize.xlarge == size) {
      return 30.0;
    }

    return 10.0;
  }
}

enum RitualsTextSize {
  small, medium, large, xlarge
}
