part of ui_atomic;

class CustomLabel extends StatelessWidget {
  final String text;


  CustomLabel({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: FontStyles.mainFont,
    );
  }
}
