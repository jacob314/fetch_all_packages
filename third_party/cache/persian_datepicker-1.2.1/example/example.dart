import 'package:flutter/material.dart';
import 'package:persian_datepicker/persian_datepicker.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  // our text controller
  final TextEditingController textEditingController = TextEditingController();

  PersianDatePickerWidget persianDatePicker;

  @override
  void initState() {
    /*Simple DatePicker*/
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      datetime: '1397/06/09',
    ).init();

    /*Range DatePicker*/
    /*persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      rangeDatePicker: true,
    ).init();*/

    /*Gregorian DatePicker*/
    /*persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      gregorianDatetime: '2018-09-08',
      outputFormat: 'YYYY/MM/DD',
    ).init();*/

    /*Inline DatePicker*/
    /*persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      datetime: '1397/06/19',
      outputFormat: 'YYYY/MM/DD',
    ).init();*/

    /*Custom Format DatePicker*/
    /*persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      datetime: '1397/06/19',
      outputFormat: 'MM - YYYY - DD',
    ).init();*/

    /*Customized DatePicker*/
    /*persianDatePicker = PersianDatePicker(
        controller: textEditingController,
        outputFormat: 'YYYY/MM/DD',
        datetime: '1397/08/13',
        finishDatetime: '1397/08/17',
        daysBorderWidth: 3,
        weekCaptionsBackgroundColor: Colors.red,
        headerBackgroundColor: Colors.blue.withOpacity(0.5),
        headerTextStyle: TextStyle(color: Colors.blue, fontSize: 17),
        headerTodayIcon: Icon(Icons.access_alarm, size: 15,),
        datePickerHeight: 280
    ).init();*/

    /*onChangeEvent*/
    /*persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      onChange: (String oldText, String newText) {
        print(oldText);
        print(newText);
      }
    ).init();*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('دیت پیکر ساده'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              // Simple Date Picker
              Container(
                child: persianDatePicker,
              ),
              TextField(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                enableInteractiveSelection: false,
                controller: textEditingController,
              ),
            ],
          );
        }),
      ),
    );
  }
}
