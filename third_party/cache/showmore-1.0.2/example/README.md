# showmore_example

Demonstrates how to use the showmore plugin.

```dart
import 'package:flutter/material.dart';

import 'package:showmore/showmore.dart';

void main()=> runApp(MaterialApp(home: HomePage()));

class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: ShowMore(
            content: 'Lorem ipsum dolor sit amet, prima liberavisse cu mei, his elit fabulas ex. Ne justo dicunt referrentur eam. Eum nulla eleifend id, ex vim ferri vitae pericula, qui epicurei interpretaris te. His ei debitis habemus intellegebat, essent assentior incorrupte ne has. Has te inani option, qui eu etiam feugiat epicurei, posidonium dissentias at nam. Ne his malis probatus consequat. Purto neglegentur vim ea, et vim reque quaestio corrumpit, perfecto singulis no his. Homero minimum efficiendi vix no. Vel an adhuc debet constituam, dicant consul percipitur nam ut, pri vide dicam feugait ei. Lorem homero graeci ex nam, labitur virtute mnesarchum in mel.',
            desiredMaxHeight: 200.0,
            desiredMinHeight: 56.0,
            )
          )
        )
      );
  }
}
```




## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
