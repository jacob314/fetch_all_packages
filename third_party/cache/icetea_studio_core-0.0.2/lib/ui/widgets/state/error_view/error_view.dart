import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/assets/assets.dart';
import 'package:icetea_studio_core/ui/widgets/state/base_state_view.dart';

class ErrorView extends BaseStateView {
  final String message;
  final VoidCallback onErrorViewInteraction;

  ErrorView(this.message, {Key key, @required this.onErrorViewInteraction}) : super(onItemInteraction: onErrorViewInteraction);

  @override
  Widget buildIconView(BuildContext context) {
    return Image(
      image: AssetImage(Assets.cspIcError),
      fit: BoxFit.fitWidth,
    );
  }

  @override
  String buildMessage(BuildContext context) {
    return message;
  }
}
