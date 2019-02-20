import 'dart:async';
import 'package:exwidgets/src/helper/ex_instance_manager.dart';
import 'package:flutter/material.dart';
import 'package:exwidgets/src/helper/input.dart';
import 'package:intl/intl.dart';

class ExDate extends StatefulWidget {
  final String id;
  final String labelText;
  final IconData iconName;
  final String format;
  final String value;

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  final bool useOutlineBorder;

  ExDate({
    Key key,
    this.id,
    this.iconName,
    this.labelText,
    this.format: "dd-MMM-yyyy",
    this.value: "",
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.useOutlineBorder = false,
  }) : super(key: key);

  @override
  _SearchDateWidget createState() => new _SearchDateWidget();
}

class _SearchDateWidget extends State<ExDate> {
  String _selectedDate = '';
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  FocusNode tempFocusNode = FocusNode();

  Future showDatePickerDialog(BuildContext context, String initialDateString,
      String inputNameStorage) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate:
            widget.initialDate == null ? initialDate : widget.initialDate,
        firstDate: widget.firstDate == null ? DateTime(1900) : widget.firstDate,
        lastDate: widget.firstDate == null
            ? DateTime.now().add(Duration(days: 1000))
            : widget.firstDate);

    if (result == null) return;
    String value = DateFormat(widget.format).format(result).toString();

    //update Value
    _selectedDate = value;
    controller.text = value;

    //save global value
    Input.setValue(
        widget.id, DateFormat("yyyy-MM-dd").format(result).toString());
  }

  static DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ExInstanceManager.setInstance(widget.id, this);

    InkWell instance = InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(tempFocusNode);
        showDatePickerDialog(context, DateTime.now().toString(), widget.id);
      },
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: false,
        decoration: InputDecoration(
          labelText: widget.labelText,
          icon: Icon(widget.iconName),
          border: widget.useOutlineBorder
              ? OutlineInputBorder(borderSide: BorderSide())
              : null,
        ),
      ),
    );

    if (_selectedDate == '') {
      _selectedDate =
          DateFormat(widget.format).format(DateTime.now()).toString();
      Input.setValue(widget.id,
          DateFormat("yyyy-MM-dd").format(DateTime.now()).toString());
    }
    controller.text = _selectedDate;

    return Container(
      padding: EdgeInsets.only(
        bottom: 8.0,
      ),
      child: instance,
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    tempFocusNode.dispose();
    super.dispose();
  }
}
