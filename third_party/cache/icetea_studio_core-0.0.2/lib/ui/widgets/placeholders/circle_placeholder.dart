import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/styles/theme_placeholder.dart';

/// Creates a circle placeholder disc with a default background
///
/// The size of the circle depends on the size of its parent
class CirclePlaceHolder extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
//        width: MediaQuery.of(context).size.width,
//        height: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: buildPlaceHolderTheme(context).backgroundColor,
        ),
      );
//      borderRadius: new BorderRadius.all(new Radius.circular(MediaQuery.of(context).size.width)),
//    );
  }
}


