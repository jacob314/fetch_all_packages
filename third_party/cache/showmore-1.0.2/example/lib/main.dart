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