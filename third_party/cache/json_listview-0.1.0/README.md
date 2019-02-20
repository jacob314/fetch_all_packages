# Json ListView

Json binder for listview, creating a listview with data coming from a rest webservice using few lines of code.

this package will give you a FutureBuilder which contains a loading indicator until your json is loaded from the web then it would provide you the json and gets a Widget from you for the row that belongs tho that json


#### On Dart Packages : https://pub.dartlang.org/packages/json_listview



## Use this package as a library

#### 1. Depend on it
Add this to your package's pubspec.yaml file:

~~~~ yaml
dependencies:
  json_listview: ^0.1.0
~~~~

#### 2. Install it
You can install packages from the command line:

with pub:

~~~~ bash
$ pub get
~~~~
with Flutter:

~~~~ bash
$ flutter packages get
~~~~
Alternatively, your editor might support pub get or flutter packages get. Check the docs for your editor to learn more.

#### 3. Import it
Now in your Dart code, you can use:

~~~~dart
import 'package:json_listview/json_listview.dart';
~~~~



# Getting Started


the package has four types of DataBiding to listview
* getting a json array list with a GET request and binding it directly to ListView
~~~~dart
var list = JsonListView.getArray(
        'https://jsonplaceholder.typicode.com/todos/',
        headers: {},  ///// request headers
        parameters: {},
        padding: 8.0,
        height: 50.0,
        listItem: (json, index) {
          return Text(json["title"]);
        }, onTap: (index) {
          print("$index selected");
        });
~~~~
* getting a json object with a GET request and bind a json array inside it to ListView
~~~~dart
var list = JsonListView.getArray(
        'https://jsonplaceholder.typicode.com/todos/',
        headers: {},  ///// request headers
        parameters: {},
        padding: 8.0,
        height: 50.0,
        arrayBinding: (JsonObject parentJson) => parentJson["list"],
        listItem: (json, index) {
          return Text(json["title"]);
        }, onTap: (index) {
          print("$index selected");
        });
~~~~
* getting a json array list with a POST request and binding it directly to ListView
~~~~dart
var list = JsonListView.getArray(
        'https://jsonplaceholder.typicode.com/todos/',
        headers: {},  ///// request headers
        parameters: {},
        padding: 8.0,
        height: 50.0,
        coding: PostCoding.JSON,
        listItem: (json, index) {
          return Text(json["title"]);
        }, onTap: (index) {
          print("$index selected");
        });
~~~~
* getting a json object with a POST request and bind a json array inside it to ListView
~~~~dart
var list = JsonListView.getArray(
        'https://jsonplaceholder.typicode.com/todos/',
        headers: {},  ///// request headers
        parameters: {},
        padding: 8.0,
        height: 50.0,
        coding: PostCoding.JSON,
        arrayBinding: (JsonObject parentJson) => parentJson["list"],
        listItem: (json, index) {
          return Text(json["title"]);
        }, onTap: (index) {
          print("$index selected");
        });
~~~~
