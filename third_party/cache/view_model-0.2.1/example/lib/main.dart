import 'dart:async';

import 'package:flutter/material.dart';
import 'package:view_model/view_model.dart';
import 'main.reflectable.dart';

void main() {
  initializeReflectable();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = ViewModelProvider.provide(HomeViewModel);
//    var factory = MyViewModelFactory(data: 'Test');
//    viewModel = ViewModelProvider().provide(HomeViewModel, factory: factory);
    return Scaffold(
      appBar: AppBar(
        title: Text('ViewModel test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              stream: viewModel.clickStream,
              builder: (context, snapshot) =>
                  Text(snapshot.hasData ? '${snapshot.data}' : '0'),
            )
          ],
        ),
      ),
      floatingActionButton: ViewModelInherited(
          viewModel: viewModel,
          child: MyWidget()),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = ViewModel.of<HomeViewModel>(context);
    return FloatingActionButton(
      onPressed: () {
        viewModel.increment();
      },
      tooltip: 'Increment',
      child: new Icon(Icons.add),
    );
  }
}

@view_model
class HomeViewModel extends ViewModel {
  StreamController<int> _clickStreamController;
  Stream<int> clickStream;
  String data;

  HomeViewModel({this.data}) {
    _clickStreamController = new StreamController<int>.broadcast();
    var counter = 0;
    clickStream = _clickStreamController.stream.map((val) {
      counter += val;
      return counter;
    });
  }

  void increment() {
    print('======== $data ========');
    _clickStreamController.add(1);
  }

  @override
  void dispose() {
    // implement dispose
    super.dispose();
  }
}

//Use the factory if you need to transfer data to the constructor
class MyViewModelFactory extends ViewModelFactory {
  String data;

  MyViewModelFactory({this.data});

  @override
  T crateViewModel<T extends ViewModel>(Type type) {
    var vm;
    switch (type) {
      case HomeViewModel:
        vm = HomeViewModel(data: data);
        break;
    }
    if (vm == null) throw Exception('Not implemented class $type');
    return vm;
  }

}
