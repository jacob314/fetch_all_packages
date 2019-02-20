import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:icetea_studio_core/ui/widgets/state/base_state_view.dart';

class LoadingView extends BaseStateView {
  @override
  Widget buildIconView(BuildContext context) {
    return new Container(width: 20.0, height: 20.0, child: new Center(child: new CircularProgressIndicator(strokeWidth: 2.0,),),);
  }

  @override
  String buildMessage(BuildContext context) {
    return '';
  }

}
