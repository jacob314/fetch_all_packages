part of ui_atomic;

class CustomBoxSection extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final Color color;
  final Widget boxIcon;

  CustomBoxSection({Key key, this.title, this.height, this.width, this.color, this.boxIcon}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: height,
            width: width,
            child: RawMaterialButton(
              constraints: BoxConstraints(maxWidth: 60.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              splashColor: Colors.white30,
              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
              fillColor: color,
              onPressed: () {},
              child: boxIcon,
            )),
        SizedBox(height: 10,),
        Text(title),
      ],
    );
  }
}
