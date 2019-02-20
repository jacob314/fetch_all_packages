import 'package:flutter/material.dart';
import 'package:extreme_widget/extreme_widget/form_element/google_place_autocomplete/api.dart';
import 'package:extreme_widget/extreme_widget/form_element/google_place_autocomplete/mapview.dart';
import 'package:extreme_widget/extreme_widget/form_element/google_place_autocomplete/model.dart';
import 'package:extreme_widget/extreme_widget/helper/input.dart';
import 'package:extreme_widget/extreme_widget/helper/nav.dart';

class GooglePlaceAutoCompleteSearchWidgetListView extends StatefulWidget {
  final String id;
  GooglePlaceAutoCompleteSearchWidgetListView({
    @required this.id,
  });

  @override
  GooglePlaceAutoCompleteSearchWidgetListViewState createState() =>
      GooglePlaceAutoCompleteSearchWidgetListViewState();
}

class GooglePlaceAutoCompleteSearchWidgetListViewState
    extends State<GooglePlaceAutoCompleteSearchWidgetListView> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  double listViewHeight = 200;

  String searchValue;
  String oldValue;

  bool enableSuffixIcon = false;
  bool focused = false;

  @override
  void initState() {
    try {
      if (Input.getValue(widget.id) == null) {
        Input.setValue(widget.id, "");
      }
    } catch (e) {
      print("GetValue Error");
      return;
    }

    try {
      searchValue = Input.getValue(widget.id);
      oldValue = searchValue;

      textEditingController.text = searchValue;

      String address = Input.getValue(widget.id);
      String placeId = Input.getValue("placeId");

      GooglePlaceApi.getPlaceDetail(placeId, address);
    } catch (e) {
      print("ERROR XXI");
      return;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    clearTextFieldValue() {
      textEditingController.text = "";
      Input.setValue(widget.id, "");
    }

    onFocus() {
      clearTextFieldValue();
      this.setState(() {
        listViewHeight = 0;
      });
    }

    onLostFocus() {
      this.setState(() {
        listViewHeight = 0;
      });
    }

    focusNode.addListener(() {
      focusNode.hasFocus ? onFocus() : onLostFocus();
    });

    onSuffixClick() {
      textEditingController.text = "";
      Input.setValue(widget.id, "");
      Input.setValue("${widget.id}_value", "");
    }

    confirmDelete() {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Ingin membatalkan pencarian lokasi?",
                  style: TextStyle(fontSize: 15.0)),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text(
                      'BACK',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Input.setValue(widget.id, oldValue);
                      Nav.close(context);
                      Nav.close(context);
                    })
              ],
            ),
      );
    }

    Widget suffixIconWidget = IconButton(
      icon: Icon(
        Icons.close,
        color: Colors.red,
      ),
      onPressed: () {
        onSuffixClick();
      },
    );

    Widget scaffold = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.red,
          icon: Icon(Icons.clear),
          onPressed: () {
            confirmDelete();
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            color: Colors.green,
            onPressed: () {
              Nav.close(context);
            },
          ),
          SizedBox(
            width: 7.0,
          ),
        ],
        title: Container(
          color: Colors.white,
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onChanged: (text) {
              if (text.length < 3) return;

              this.setState(() {
                listViewHeight = 200;
              });

              this.setState(() {
                searchValue = textEditingController.text;
              });
            },
            // onSubmitted: (text) {
            //   this.setState(() {
            //     searchValue = textEditingController.text;
            //   });
            // },
            decoration: InputDecoration(
              suffixIcon: enableSuffixIcon == true ? suffixIconWidget : null,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 300,
            height: listViewHeight,
            child: FutureBuilder<List<GooglePlaceModel>>(
              future: GooglePlaceApi.fetchResult(searchValue),
              builder: (context, snapshot) {
                if (searchValue == null)
                  return Center(child: Text("Write something.."));
                if (snapshot.hasError) print(snapshot.error);
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    GooglePlaceModel searchResult = snapshot.data[index];
                    return InkWell(
                      child: ListTile(
                        title: Text('${searchResult.description}'),
                      ),
                      onTap: () {
                        Input.setValue(widget.id, searchResult.description);
                        Input.setValue("${widget.id}_id", searchResult.id);
                        Input.setValue(
                            "${widget.id}_placeId", searchResult.placeId);

                        this.setState(() {
                          listViewHeight = 0;
                        });
                        GooglePlaceApi.getPlaceDetail(
                            searchResult.placeId, searchResult.description);
                        textEditingController.text = searchResult.description;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        //Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
              child: GoogleMapView(),
            ),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        confirmDelete();
      },
      child: scaffold,
    );
  }
}
