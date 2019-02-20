import 'package:flutter/material.dart';
import 'package:page_transformer/src/intro_page_item.dart';
import 'package:page_transformer/src/intro_page_view.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SliderView(
        slideItems: <SlideItem>[
          new SlideItem(title: 'Writing things together is what we do best!', category: 'COLLABORATION', imageUrl: 'assets/1.png',),
          new SlideItem(title: 'Occasionally wearing pants is a good idea.', category: 'CULTURE', imageUrl: 'assets/2.png',),
          new SlideItem(title: 'We might have the best team spirit ever.', category: 'SPIRIT', imageUrl: 'assets/3.png',),
        ],
        viewportFraction: 0.95,
        height: 300.0,
      ),
    );
  }
}