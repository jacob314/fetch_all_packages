import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
    this.isPickTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final bool isPickTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1930, 1),
        lastDate: new DateTime.now()
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime
    );

    if (picked != null && picked != selectedTime) {
      selectTime(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
            flex: 4,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(labelText),
                new Padding(padding: new EdgeInsets.only(top: 5.0)),
                _buildDateView(context)
              ],
            )
        ),
        new SizedBox(width: isPickTime ?? false ? 12.0 : 0.0),
        isPickTime ?? false ?
        new Expanded(
            flex: 3,
            child: _buildTimeView(context)
        ) : new Container(),
      ],
    );
  }

  _buildDateView(BuildContext context) {
    return new FlatButton(
      padding: const EdgeInsets.all(0.0),
      onPressed: () {
        _selectDate(context);
      },
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(2.0),
          side: new BorderSide(
              color: Theme.of(context).inputDecorationTheme.enabledBorder.borderSide.color,
              width: 1.0)),
      child: new Container(
        padding: new EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Center(child: new SizedBox(width: 20.0, height: 30.0, child: new Icon(
              Icons.calendar_view_day,
              size: 18.0,
              color: Theme.of(context).primaryColor
            ),),),
            new Expanded(
              child: new Container(
                padding: new EdgeInsets.only(left: 10.0),
                child: new Text(
                    new DateFormat.yMMMd().format(selectedDate),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor
                    )
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }

  _buildTimeView(BuildContext context) {
    return new FlatButton(
      padding: const EdgeInsets.all(0.0),
      onPressed: () {
        _selectTime(context);
      },
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(2.0),
          side: new BorderSide(
              width: 1.0)),
      child: new Container(
        padding: new EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Center(child: new SizedBox(width: 20.0, height: 30.0, child: new Icon(
              Icons.timer,
              size: 20.0,
              color: Theme.of(context).primaryColor,
            ),),),
            new Expanded(
              child: new Container(
                padding: new EdgeInsets.only(left: 10.0),
                child: new Text(selectedTime.format(context)),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}