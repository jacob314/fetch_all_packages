import 'package:flutter/material.dart';

class AndroidButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double height;

  AndroidButton({this.onTap, this.text, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: ButtonTheme(
        height: height ?? 50.0,
        child: RaisedButton(
          color: Colors.green,
          splashColor: Colors.white30,
          onPressed: () {

          },
          child: Text(
            text ?? 'Test',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
