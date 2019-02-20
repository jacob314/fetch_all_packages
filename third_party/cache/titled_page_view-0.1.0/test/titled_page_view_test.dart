import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:titled_page_view/titled_page_view.dart';

void main() {
  testWidgets('Default constructor (using lists)', (WidgetTester tester) async {
    int value = 0;

    List<Widget> list = [
      Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {value = 1;},
            child: Container(
              height: 300,
              child: Text('Screen1'),
            ),
          )
        ],
      ),
      Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {value = 2;},
            child: Container(
              height: 300,
              child: Text('Screen2'),
            ),
          )
        ],
      ),
    ];

    List<Widget> titles = [
      Text('a'),
      Text('b')
    ];

    PageController controller = PageController(initialPage: 0);
    Widget myTitledPageView = TitledPageView(
      children: list, titleChildren: titles, controller: controller,
    );

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Scaffold(
              body: myTitledPageView,
            ),
          );
        },
      )
    );
    expect(value, equals(0));

    // ----------------------------------------
    // Test fling gestures and screen responsiveness
    await tester.tap(find.text('Screen1'));
    expect(value, equals(1));
    expect(controller.page, equals(0.0));

    await tester.fling(find.byWidget(myTitledPageView), Offset(-100, 0), 500);
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(1.0));

    await tester.tap(find.text('Screen2'));
    expect(value, equals(2));

    await tester.fling(find.byWidget(myTitledPageView), Offset(100, 0), 500);
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(0.0));

//     Test that we cannot go to negative pages
    await tester.fling(find.byWidget(myTitledPageView), Offset(100, 0), 500);
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(0.0));


    // ----------------------------------------
    // Test control buttons and screen responsiveness
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    await tester.tap(find.text('Screen2'));
    expect(value, equals(2));
    expect(controller.page, equals(1.0));

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    await tester.tap(find.byWidget(myTitledPageView));
    expect(value, equals(1));
    expect(controller.page, equals(2.0));

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(0.0));

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(0.0));
  });

  testWidgets('Builder constructor', (WidgetTester tester) async {
    int value = 0;

    List<Widget> list = [
      Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {value = 1;},
            child: Container(
              height: 300,
              child: Text('Screen1'),
            ),
          )
        ],
      ),
      Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {value = 2;},
            child: Container(
              height: 300,
              child: Text('Screen2'),
            ),
          )
        ],
      ),
    ];

    List<Widget> titles = [
      Text('a'),
      Text('b')
    ];

    PageController controller = PageController(initialPage: 0);
    Widget myTitledPageView = TitledPageView.builder(
      bodyBuilder: (BuildContext context, int index) {
        return list[index % list.length];
      },
      titleBuilder: (BuildContext context, int index) {
        return titles[index % list.length];
      },
      controller: controller,
    );

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Scaffold(
              body: myTitledPageView,
            ),
          );
        },
      )
    );
    expect(value, equals(0));

    // ----------------------------------------
    // Test fling gestures and screen responsiveness
    await tester.tap(find.text('Screen1'));
    expect(value, equals(1));
    expect(controller.page, equals(0.0));

    await tester.fling(find.byWidget(myTitledPageView), Offset(-100, 0), 500);
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(1.0));

    await tester.tap(find.text('Screen2'));
    expect(value, equals(2));

    await tester.fling(find.byWidget(myTitledPageView), Offset(100, 0), 500);
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(0.0));

//     Test that we cannot go to negative pages
    await tester.fling(find.byWidget(myTitledPageView), Offset(100, 0), 500);
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(0.0));


    // ----------------------------------------
    // Test control buttons and screen responsiveness
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    await tester.tap(find.text('Screen2'));
    expect(value, equals(2));
    expect(controller.page, equals(1.0));

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    await tester.tap(find.byWidget(myTitledPageView));
    expect(value, equals(1));
    expect(controller.page, equals(2.0));

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(0.0));

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle(Duration(milliseconds: 16));
    expect(controller.page, equals(0.0));
  });
}
