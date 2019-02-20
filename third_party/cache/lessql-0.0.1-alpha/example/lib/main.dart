import 'package:flutter/material.dart';
import 'package:lessql/lessql.dart';
import 'dart:math';


class FooDB extends LesDB{

  @override
  String getName() {
    return 'foo_db';
  }

  @override
  int getVersion() {
    return 1;
  }

}

class FooTable1 extends LesTable{

  @override
  List<String> getColumnNames() {
    return ['c1','c2','c3','c4'];
  }

  @override
  List<String> getColumnTypes() {
    return [Contract.TYPE_STRING,Contract.TYPE_NUMBER,Contract.TYPE_NUMBER,Contract.TYPE_NUMBER,];
  }

  @override
  String getTableName() {
    return 'table1';
  }
  @override
  int getPrimaryColumnIndex() {
    return -1;
  }

  @override
  String getAutoIncrementID(){
    return "id";
  }
}

class FooEntity1 extends LesEntity{

  String c1;
  int c2;
  int c3;
  int c4;

  FooEntity1(this.c1,this.c2,this.c3,this.c4);

  @override
  List getValues() {
    return [c1,c2,c3,c4];
  }
}

class FooTable2 extends LesTable{

  @override
  List<String> getColumnNames() {
    return ['c1','c2',];
  }

  @override
  List<String> getColumnTypes() {
    return [Contract.TYPE_NUMBER,Contract.TYPE_STRING];
  }

  @override
  String getTableName() {
    return 'table2';
  }

  @override
  int getPrimaryColumnIndex() {
    return 0;
  }

  @override
  String getAutoIncrementID(){
    return "";
  }
}

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> implements LesSQLCallback{

  String des = "no opration";
  String ip = "";
  @override
  initState() {
    super.initState();
    LesSQL.initSelf(this);
    LesSQL.initLesDB(new FooDB(), [new FooTable1(),new FooTable2()]).then(_updateDes);
    _updateIP("确保你的手机和电脑连接同意路由器");
  }

  _insert(){
    Random random = new Random();
    FooEntity1 entity1 = new FooEntity1(random.nextInt(10000).toString(), random.nextInt(10000), random.nextInt(10000), random.nextInt(10000));
    LesSQL.insert(new FooTable1(), entity1.getValues()).then(_updateDes);
  }

  _updateDes(String str){
    setState(()=>des = str);
  }
  
  _updateIP(String str){
    setState(()=>ip = str);
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app')
        ),
        body: new Center(
          child: new Column(children: <Widget>[
            new Text(ip,style: new TextStyle(fontSize: 20.0,color:Colors.black),),
            new Text(des),
            new RaisedButton(onPressed: _insert, child:  new Text("insert",style: new TextStyle(color: Colors.black,fontSize: 20.0),))
          ],)
        )
      )
    );
  }
  @override
  initDBIP(String ipAddress) {
    _updateIP(ipAddress);
  }
}
