import 'package:flutter/material.dart';

class LoadMoreItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Center(
            child: new SizedBox(
              width: 20.0,
              height: 20.0,
              child: new CircularProgressIndicator(strokeWidth: 2.0),
            )
        )
    );
  }
}
