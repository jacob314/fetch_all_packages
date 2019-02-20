library json_listview;

import 'package:networkjson/networkjson.dart';
import 'package:flutter/material.dart';


class JsonListView {
  static FutureBuilder<JsonObject> getObject(String url,
      {Map<String, dynamic> parameters,
        dynamic headers,
        Function(int) onTap,
        double height = 80.0,
        double padding = 0.0,
        JsonArray Function(JsonObject) arrayBinding,
        Widget Function(JsonObject, int) listItem}) {
    return FutureBuilder<JsonObject>(
      future: JsonObject.get(url, parameters: parameters, headers: headers),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          JsonArray list = arrayBinding(snapshot.data);
          ListView lv = ListView.builder(
              padding: EdgeInsets.all(padding),
              itemExtent: height,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                JsonObject json = list.object(index);
                return GestureDetector(
                  child: listItem(json, index),
                  onTap: () => onTap(index),
                );
              });
          return lv;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  static FutureBuilder<JsonArray> getArray(String url,
      {Map<String, dynamic> parameters,
        dynamic headers,
        Function(int) onTap,
        double height = 80.0,
        double padding = 0.0,
        Widget Function(JsonObject, int) listItem}) {
    return FutureBuilder<JsonArray>(
      future: JsonArray.get(url, parameters: parameters, headers: headers),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          JsonArray list = snapshot.data;
          ListView lv = ListView.builder(
              padding: EdgeInsets.all(padding),
              itemExtent: height,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                JsonObject json = list.object(index);
                return GestureDetector(
                  child: listItem(json, index),
                  onTap: () => onTap(index),
                );
              });
          return lv;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
  static FutureBuilder<JsonObject> postObject(String url,
      {Map<String, dynamic> parameters,
        dynamic headers,
        Function(int) onTap,
        double height = 80.0,
        double padding = 0.0,
        JsonArray Function(JsonObject) arrayBinding,
        Widget Function(JsonObject, int) listItem, PostCoding coding = PostCoding.UrlEncoded}) {
    return FutureBuilder<JsonObject>(
      future: JsonObject.post(url, parameters: parameters, headers: headers, coding: coding),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          JsonArray list = arrayBinding(snapshot.data);
          ListView lv = ListView.builder(
              padding: EdgeInsets.all(padding),
              itemExtent: height,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                JsonObject json = list.object(index);
                return GestureDetector(
                  child: listItem(json, index),
                  onTap: () => onTap(index),
                );
              });
          return lv;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  static FutureBuilder<JsonArray> postArray(String url,
      {Map<String, dynamic> parameters,
        dynamic headers,
        Function(int) onTap,
        double height = 80.0,
        double padding = 0.0,
        Widget Function(JsonObject, int) listItem, PostCoding coding = PostCoding.UrlEncoded}) {
    return FutureBuilder<JsonArray>(
      future: JsonArray.post(url, parameters: parameters, headers: headers, coding: coding),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          JsonArray list = snapshot.data;
          ListView lv = ListView.builder(
              padding: EdgeInsets.all(padding),
              itemExtent: height,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                JsonObject json = list.object(index);
                return GestureDetector(
                  child: listItem(json, index),
                  onTap: () => onTap(index),
                );
              });
          return lv;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
