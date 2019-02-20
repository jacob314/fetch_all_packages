import 'package:flutter/material.dart';

///
/// This widget using like [Chip] widget but custom for this project
///
class ChipEntity {
  String id;
  String name;
  dynamic value;
  IconData icon;

  ChipEntity(this.id, this.name, this.value, this.icon);

}

class CustomChip extends StatelessWidget {

  final ChipEntity data;
  final bool isAllowRemove;
  final ValueChanged<ChipEntity> onItemRemoved;

  CustomChip({@required this.data, @required this.isAllowRemove, this.onItemRemoved})
      : assert(data != null),
        assert(isAllowRemove);

  @override
  Widget build(BuildContext context) {
    bool isShowIcon = (data != null && data.icon != null && data.icon != null);

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Theme.of(context).accentColor,
          border: new Border.all(color: Theme.of(context).accentColor)),
      child: new Row(
        children: <Widget>[
          isShowIcon
              ? new Container(
                  padding: new EdgeInsets.only(left: 5.0, right: 10.0) ,
                  child: data.icon != null
                      ? new SizedBox(
                          height: 30.0,
                          child: new Icon(
                            data.icon,
                            color: Theme.of(context).accentIconTheme.color,
                            size: 16.0,
                          ),
                        )
                      : new Container())
              : new Container(),
          new Expanded(
            child: new Text(
              data.name,
              style: new TextStyle(color: Theme.of(context).accentTextTheme.title.color),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          new InkWell(
            onTap: () {
              onItemRemoved(data);
            },
            child: new Icon(
              Icons.close,
              color: Theme.of(context).accentTextTheme.title.color,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
