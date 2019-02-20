import 'package:flutter/material.dart';

class ViewLoading {
  static final ViewLoading _loader = ViewLoading._internal();
  static BuildContext _context;
  static bool _isLoading = false;

  ViewLoading._internal();

  static ViewLoading of(BuildContext context){
    _context = context;
    return _loader;
  }

  startLoading() {
    _isLoading = true;
     print("loading");

    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new Center(
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  strokeWidth: 2.0,
                )
              )
            ),
          );
        }
    );
  }

  stopLoading() {
    if (_isLoading) {
      Navigator.pop(_context);
      print("stop loading");
    }
    _isLoading = false;
  }
}
