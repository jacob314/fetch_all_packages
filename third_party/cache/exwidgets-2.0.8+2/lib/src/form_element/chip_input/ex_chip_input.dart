import 'package:flutter/material.dart';
import 'package:exwidgets/src/form_element/chip_input/listview.dart';
import 'package:exwidgets/src/helper/input.dart';
import 'package:exwidgets/src/helper/nav.dart';

class ExChipInput extends StatefulWidget {
  final String id;
  final String hintText;
  final IconData iconName;
  final String dataSource;
  final String valueField;
  final String value;
  final bool enabled;

  ExChipInput({
    Key key,
    @required this.id,
    @required this.hintText,
    this.iconName,
    this.value: "",
    this.enabled,
    @required this.dataSource,
    @required this.valueField,
  }) : super(key: key);

  @override
  StandartChipInputWidget createState() => StandartChipInputWidget();
}

class StandartChipInputWidget extends State<ExChipInput> {
  List<String> chips = [];

  @override
  void initState() {
    Input.setValue(widget.id, widget.value);
    super.initState();
  }

  void loadFromInputToList() {
    if (Input.getValue(widget.id) == null ||
        Input.getValue(widget.id).length == 0) return;

    List<String> values = Input.getValue(widget.id).split("|").toList();
    values.removeLast();
    chips = values;
  }

  void removeSelectedFromInput(String key) {
    List<String> values = Input.getValue(widget.id).split("|").toList();
    values.removeLast();

    for (var i = 0; i < values.length; i++) {
      if (values[i].indexOf(key) > -1) {
        values.removeAt(i);
      }
    }

    String newValues = values.join("|") + "|";
    Input.setValue(widget.id, newValues);
  }

  @override
  Widget build(BuildContext context) {
    if (Input.getValue(widget.id) != null) {
      try {
        loadFromInputToList();
      } catch (e) {
        print("Load from Input to List Error");
        return Text("ERROR");
      }
    }

    var mainRow = Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 14.0),
          // color: Colors.red,
          height: 60.0,
          child: Icon(widget.iconName),
        ),
        Expanded(
          child: Container(
            // color: Colors.yellow,
            height: 60.0,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 20.0,
                  // color: Colors.green,
                  child: Text(widget.hintText),
                ),
                Container(
                  width: double.infinity,
                  height: 40.0,
                  padding: EdgeInsets.all(2.0),
                  // color: Colors.blue,
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        child: Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.add),
                            foregroundColor: Colors.white,
                          ),
                          label: Text('Add'),
                        ),
                        onTap: () {
                          Nav.open(
                            context,
                            ExChipListView(
                              id: widget.id,
                              dataSource: widget.dataSource,
                              valueField: widget.valueField,
                            ),
                          ).then((done) {
                            print("Closed!");
                            setState(() {
                              chips = chips;
                            });
                          });
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "* Double tap untuk menghapus",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    List<Widget> chipsWidgets = [];
    for (var i = 0; i < chips.length; i++) {
      try {
        String key = chips[i].split(",")[0];
        String value = chips[i].split(",")[1];

        var item = Row(
          children: <Widget>[
            InkWell(
              child: Chip(
                avatar: CircleAvatar(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  child: Text(
                    value[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                label: Text("$value"),
              ),
              onDoubleTap: () {
                print(key + ":" + chips.length.toString());
                setState(() {
                  removeSelectedFromInput(key);
                });
              },
            ),
          ],
        );

        chipsWidgets.add(item);
      } catch (e) {
        print("ERROR disni pak..");
      }
    }

    var rowItems = Container(
      // color: Colors.yellow,
      padding: EdgeInsets.only(left: 34.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              // color: Colors.yellow,
              child: Column(
                children: chipsWidgets,
              ),
            ),
          ),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Column(
        children: <Widget>[
          mainRow,
          rowItems,
        ],
      ),
    );
  }
}
