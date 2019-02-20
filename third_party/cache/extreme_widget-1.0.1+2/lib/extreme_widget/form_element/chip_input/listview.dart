import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/helper/input.dart';
import 'package:extreme_widget/extreme_widget/helper/nav.dart';
import 'package:extreme_widget/extreme_widget/loading/extreme_loading.dart';

class ExChipListView extends StatefulWidget {
  final String id;
  final String dataSource;
  final String valueField;

  ExChipListView({
    @required this.id,
    @required this.dataSource,
    @required this.valueField,
  });

  @override
  ExChipListViewState createState() => ExChipListViewState();
}

class ExChipListViewState extends State<ExChipListView> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String searchValue = "";
  bool enableSuffixIcon = false;
  bool focused = false;

  List<String> dataList = [];
  List<String> selectedDataList = [];
  bool isLoading = true;

  loadData() async {
    try {
      var querySnapshot =
          Firestore.instance.collection(widget.dataSource).getDocuments();
      var docs = await querySnapshot.then((docs) {
        return docs;
      });

      for (var i = 0; i < docs.documents.length; i++) {
        String key = docs.documents[i].documentID;
        String value = docs.documents[i].data[widget.valueField];

        if (selectedDataList
                .where((str) => (str.indexOf(value) > -1))
                .toList()
                .length >
            0) {
          setItemSelected(key, value);
        }
        dataList.add("$key,$value");
      }

      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("loadData Error>>>");
    }
  }

  void loadFromInputToList() {
    try {
      if (Input.getValue(widget.id)==null) return;

      List<String> values = Input.getValue(widget.id).split("|").toList();
      values.removeLast();
      selectedDataList = values;
    } catch (e) {
      print("loadFromInputToList Error");
    }
  }

  @override
  void initState() {
    loadFromInputToList();
    loadData();
    super.initState();

    try {
      //logic
    } catch (e) {
      //apapun errornya, disini masuknya >__<
    }
  }

  Map<String, String> selectedList = HashMap<String, String>();

  bool isItemSelected(String key) {
    if (selectedList[key] != null) {
      return true;
    }
    return false;
  }

  void setItemSelected(String key, String value) {
    selectedList[key] = "$key,$value";
    saveSelectedItem();
  }

  void removeItem(String key) {
    selectedList[key] = null;
    saveSelectedItem();
  }

  void saveSelectedItem() {
    String values = "";

    for (var indexKey in selectedList.keys) {
      if (selectedList[indexKey] == null) continue;

      var key = selectedList[indexKey].split(",")[0];
      var value = selectedList[indexKey].split(",")[1];

      values += "$key,$value|";
    }

    print(values);
    Input.setValue(widget.id, values);
  }

  void onItemTap(key, value) {
    print("Key: $key");
    print("Value: $value");

    setState(() {
      if (isItemSelected(key)) {
        removeItem(key);
      } else {
        setItemSelected(key, value);
      }
    });
  }

  getListViewBuilder() {
    return ListView.builder(
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        var key = dataList[index].split(",")[0];
        var value = dataList[index].split(",")[1];

        if (value.toLowerCase().indexOf(searchValue.toLowerCase() ?? "") ==
            -1) {
          return Container();
        }

        return InkWell(
          child: Card(
            color: isItemSelected(key) ? Colors.yellow : Colors.white,
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Text(value),
            ),
          ),
          onTap: () => onItemTap(key, value),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ExLoading.tetrisLoading();
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.blue,
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () {
              Nav.close(context);
            },
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actions: <Widget>[
            SizedBox(
              width: 7.0,
            ),
          ],
          title: Container(
            color: Colors.white,
            child: TextField(
              autofocus: true,
              decoration: InputDecoration.collapsed(
                hintText: "Search",
              ),
              onChanged: (text) {
                print(text);
                setState(() {
                  searchValue = text;
                });
              },
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(12.0),
          child: getListViewBuilder(),
        ),
      );
    }
  }
}
