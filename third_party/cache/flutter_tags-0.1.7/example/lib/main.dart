import 'package:flutter/material.dart';

import 'package:flutter_tags/input_tags.dart';
import 'package:flutter_tags/selectable_tags.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget
{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'flutter_tags - Test'),
    );
  }
}


class MyHomePage extends StatefulWidget
{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin
{
  TabController _tabController;
  ScrollController _scrollViewController;

  final List<String> _list = [
    '0','SDk','plugin updates','Facebook',
    'First','Italy','France','Spain','Dart','Foo','Select','lorem ip',
    'Star','Flutter Selectable Tags','1','Hubble','2','Input flutter tags','A B C','Android Studio developer','welcome to the jungle','very large text',
  ];

  bool _symmetry = false;
  bool _singleItem = false;
  int _column = 4;
  double _fontSize = 14;

  String _selectableOnPressed = '';
  String _inputOnPressed = '';

  List<Tag> _selectableTags = [];
  List<String> _inputTags = [];

  List _icon=[
    Icons.home,
    Icons.language,
    Icons.headset
  ];


  @override
  void initState()
  {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollViewController = ScrollController();

    int cnt = 0;
    _list.forEach((item)
    {
        _selectableTags.add (
            Tag (id: cnt,
                title: item,
                active: (_singleItem) ? ( cnt==3 ? true:false ) : true,
                icon: (item == '0' || item == '1' || item == '2') ?
                _icon[ int.parse (item
                ) ] : null
            )
        );
        cnt++;
    }
    );

    _inputTags.addAll(
        [
            'first tag',
            'android world',
            'pic',
            'substring',
            'last tag',
            'enable',
            'act',
            'first',
            'return',
            'lollipop',
            'loop',
        ]
    );

  }


  @override
  Widget build(BuildContext context)
  {
        return Scaffold(
          body: NestedScrollView(
              controller: _scrollViewController,
              headerSliverBuilder: (BuildContext context,bool boxIsScrolled){
                return <Widget>[
                  SliverAppBar(
                    title: Text("flutter_tags - Test"),
                    centerTitle: true,
                    pinned: true,
                    expandedHeight: 110.0,
                    floating: true,
                    forceElevated: boxIsScrolled,
                    bottom: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(fontSize: 18.0),
                      tabs: [
                        Tab(text: "Selectable"),
                        Tab(text: "Input"),
                      ],
                      controller: _tabController,
                    ),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children:  [
                  ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: _symmetry,
                                        onChanged: (a){
                                          setState(() {
                                            _symmetry = !_symmetry;
                                          });
                                        }
                                    ),
                                    Text('Symmetry')
                                  ],
                                ),
                                onTap: (){
                                  setState(() {
                                    _symmetry = !_symmetry;
                                  });
                                },
                              ),
                              GestureDetector(
                                  child: Row(
                                      children: <Widget>[
                                          Checkbox(
                                              value: _singleItem,
                                              onChanged: (a){
                                                  setState(() {
                                                      _singleItem = !_singleItem;
                                                  });
                                              }
                                          ),
                                          Text('Single Item')
                                      ],
                                  ),
                                  onTap: (){
                                      setState(() {
                                          _singleItem = !_singleItem;
                                      });
                                  },
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                              ),
                              DropdownButton(
                                hint: Text(_column.toString()),
                                items: _buildItems(),
                                onChanged: (a) {
                                  setState(() {
                                    _column = a;
                                  });
                                },
                              ),
                              Text("Columns")
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Font Size'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Slider(
                                    value: _fontSize,
                                    min: 6,
                                    max: 30,
                                    onChanged: (a){
                                      setState(() {
                                        _fontSize = (a.round()).toDouble();
                                      });
                                    },
                                  ),
                                  Text(_fontSize.toString()),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Container(
                            child:
                            SelectableTags(
                              tags: _selectableTags,
                              columns: _column,
                              fontSize: _fontSize,
                              symmetry: _symmetry,
                              singleItem: _singleItem,
                              //activeColor: Colors.deepPurple,
                              //boxShadow: [],
                              //margin: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                              onPressed: (tag){
                                setState(() {
                                  _selectableOnPressed = tag.toString();
                                });
                              },
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Divider(color: Colors.blueGrey,)
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child: Text("OnPressed",style: TextStyle(fontSize: 18),)),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              alignment: Alignment.topLeft,
                              child: Text(_selectableOnPressed)
                          )
                        ],
                      ),
                    ],
                  ),
                  ListView(
                      children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  GestureDetector(
                                      child: Row(
                                          children: <Widget>[
                                              Checkbox(
                                                  value: _symmetry,
                                                  onChanged: (a){
                                                      setState(() {
                                                          _symmetry = !_symmetry;
                                                      });
                                                  }
                                              ),
                                              Text('Symmetry')
                                          ],
                                      ),
                                      onTap: (){
                                          setState(() {
                                              _symmetry = !_symmetry;
                                          });
                                      },
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(20),
                                  ),
                                  DropdownButton(
                                      hint: Text(_column.toString()),
                                      items: _buildItems(),
                                      onChanged: (a) {
                                          setState(() {
                                              _column = a;
                                          });
                                      },
                                  ),
                                  Text("Columns")
                              ],
                          ),
                          Column(
                              children: <Widget>[
                                  Text('Font Size'),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                          Slider(
                                              value: _fontSize,
                                              min: 6,
                                              max: 30,
                                              onChanged: (a){
                                                  setState(() {
                                                      _fontSize = (a.round()).toDouble();
                                                  });
                                              },
                                          ),
                                          Text(_fontSize.toString()),
                                      ],
                                  ),
                              ],
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child:
                              InputTags(
                                  tags: _inputTags,
                                  columns: _column,
                                  fontSize: _fontSize,
                                  symmetry: _symmetry,
                                  iconBackground: Colors.green[800],
                                  //boxShadow: [],
                                  //color: Colors.red,
                                  //margin: EdgeInsets.all(15),
                                  lowerCase: true,
                                  autofocus: true,
                                  onDelete: (tag){
                                      print(tag);
                                  },
                                  onInsert: (tag){
                                      print(tag);
                                  },
                              ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                  child: Text('Print all Tags'),
                                  onPressed: (){
                                      _inputOnPressed ='';
                                      _inputTags.forEach((tag) =>
                                          setState(() {
                                              _inputOnPressed+='${tag},\n';
                                          })
                                      );
                                  }
                              ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(_inputOnPressed),
                          ),
                      ],
                  )
                ],
              )
          ),
        );
  }


  List<DropdownMenuItem> _buildItems()
  {
    List<DropdownMenuItem> list = [];

    int count = 15;

    for(int i = 1; i < count; i++)
      list.add(
        DropdownMenuItem(
          child: Text(i.toString() ),
          value: i,
        ),
      );

    return list;
  }
}
