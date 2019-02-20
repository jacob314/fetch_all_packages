part of ui_atomic;

class CustomSectionView extends StatefulWidget {
  final String title;

  CustomSectionView({Key key, this.title}) : super(key: key);
  @override
  _CustomSectionViewState createState() => _CustomSectionViewState();
}

class _CustomSectionViewState extends State<CustomSectionView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 25),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  child: CustomBoxSection(
                title: 'Reservation',
                height: 60,
                width: 110,
                color: ColorsStyle.baraRed,
                boxIcon: Icon(
                  Icons.build,
                  color: Colors.white,
                ),
              )),
              Expanded(
                  child: CustomBoxSection(
                title: 'Reservation',
                height: 60,
                width: 110,
                color: ColorsStyle.mainColor,
                boxIcon: Icon(
                  Icons.event_seat,
                  color: Colors.white,
                ),
              )),
              Expanded(
                  child: CustomBoxSection(
                title: 'Reservation',
                height: 60,
                width: 110,
                color: ColorsStyle.veryBerry,
                boxIcon: Icon(
                  Icons.ac_unit,
                  color: Colors.white,
                ),
              )),
            ],
          )
        ],
      ),
    );
  }
}
