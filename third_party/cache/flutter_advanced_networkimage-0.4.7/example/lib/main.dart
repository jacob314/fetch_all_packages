import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

void main() => runApp(MaterialApp(
      title: 'Flutter Example',
      theme: ThemeData(primaryColor: Colors.blue),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Example();
}

class Example extends State<MyApp> {
  ByteData imageCropperData;

  cropImage(ByteData data) => setState(() => imageCropperData = data);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Advanced Network Image Example'),
          bottom: TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'load image'),
              Tab(text: 'zoomable widget'),
              Tab(text: 'zoomable list'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            TransitionToImage(
              image: AdvancedNetworkImage(
                'https://assets-cdn.github.com/images/modules/logos_page/GitHub-Mark.png',
                // loadedCallback: () => print('It works!'),
                // loadFailedCallback: () => print('Oh, no!'),
                // loadingProgress: (double progress) => print(progress),
                // disableMemoryCache: true,
              ),
              loadedCallback: () => print('It works!'),
              loadFailedCallback: () => print('Oh, no!'),
              // disableMemoryCache: true,
              fit: BoxFit.contain,
              placeholder: Container(
                width: 300.0,
                height: 300.0,
                color: Colors.transparent,
                child: const Icon(Icons.refresh),
              ),
              width: 300.0,
              height: 300.0,
              enableRefresh: true,
              loadingWidgetBuilder: (progress) =>
                  Center(child: Text(progress.toString())),
            ),
            ZoomableWidget(
              panLimit: 0.7,
              maxScale: 2.0,
              minScale: 0.5,
              multiFingersPan: false,
              enableRotate: true,
              autoCenter: true,
              child: Image(
                image: AdvancedNetworkImage(
                  'https://assets-cdn.github.com/images/modules/logos_page/GitHub-Mark.png',
                ),
              ),
              // onZoomChanged: (double value) => print(value),
            ),
            Builder(builder: (BuildContext context) {
              GlobalKey _key = GlobalKey();
              return ZoomableList(
                childKey: _key,
                maxScale: 2.0,
                child: Column(
                  key: _key,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image(
                      image: AdvancedNetworkImage(
                        'https://assets-cdn.github.com/images/modules/logos_page/GitHub-Mark.png',
                      ),
                    ),
                    Image(
                      image: AdvancedNetworkImage(
                        'https://assets-cdn.github.com/images/modules/logos_page/GitHub-Mark.png',
                      ),
                    ),
                    Image(
                      image: AdvancedNetworkImage(
                        'https://assets-cdn.github.com/images/modules/logos_page/GitHub-Mark.png',
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
