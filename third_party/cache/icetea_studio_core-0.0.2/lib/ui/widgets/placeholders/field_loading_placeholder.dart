import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/theme_placeholder.dart';

/// Display a placeholder Textbox with a background for a field
///
/// Use this to fill up the space of a field while the View is being initialized
class FieldLoadingPlaceHolder extends StatelessWidget {
  final double height;
  final double width;

  FieldLoadingPlaceHolder({this.height: 5.0, this.width: 50.0});

  @override
  Widget build(BuildContext context) {
      return new Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Placeholder(
          color: buildPlaceHolderTheme(context).backgroundColor,
          fallbackHeight: height,
          fallbackWidth: width,
          strokeWidth: height,
        )
    );
  }
}
