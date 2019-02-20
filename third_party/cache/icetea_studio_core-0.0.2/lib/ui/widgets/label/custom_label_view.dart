import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/widgets/html/html_text_view.dart';

class CustomLabelView extends StatelessWidget {
  final String value;
  final bool isRequired;

  CustomLabelView({@required this.value, @required this.isRequired})
      : assert(value != null),
        assert(isRequired != null);

  @override
  Widget build(BuildContext context) {
    String formatText = isRequired ? '$value <span style=\"color: #FF0000\">*</span>' : value;

    return new Container(
      padding: const EdgeInsets.only(bottom: 0.0),
      margin: const EdgeInsets.all(0.0),
      alignment: Alignment.topLeft,
      child: new HtmlTextView(
        data: formatText,
      ),
    );
  }
}
