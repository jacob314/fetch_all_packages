import 'package:flutter/material.dart';

class ListPicker extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String placeholder;
  final String text;
  final int selectedItems;
  final bool isMultiple;
  final bool isRequired;
  final Key key;
  final String helpText;

  ListPicker({
    this.key,
    @required this.icon,
    @required this.onPressed,
    @required this.placeholder,
    this.text,
    this.isRequired = false,
    this.helpText
  }) :
        selectedItems = 0,
        isMultiple = false,
        assert(icon != null),
        assert(onPressed != null),
        assert(placeholder != null),
        super(key: key);

  ListPicker.buildMulti({
    this.key,
    @required this.icon,
    @required this.onPressed,
    @required this.placeholder,
    @required this.selectedItems,
    this.isRequired = false,
    this.helpText
  }) : isMultiple = true,
        text = '',
        assert(selectedItems != null),
        assert(icon != null),
        assert(onPressed != null),
        assert(placeholder != null),
        super(key: key);

  @override
  ListPickerState createState() => ListPickerState();
}

class ListPickerState extends State<ListPicker> {
  bool _isValidateSubmitted = false;

  bool validate() {
    setState(() {
      _isValidateSubmitted = true;
    });

    if (widget.isRequired) {
      return widget.isMultiple ? widget.selectedItems > 0 : (widget.text != null && widget.text.isNotEmpty);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool isRequiredError = false;
    String text = widget.placeholder;
    Color textColor = Theme.of(context).textTheme.subhead.color;
    Color iconColor = Theme.of(context).primaryColor;
    Color borderColor = Theme.of(context).inputDecorationTheme.enabledBorder.borderSide.color;
    Color helperColor = Theme.of(context).hintColor;

    if (widget.isMultiple) {
      isRequiredError = widget.isRequired && widget.selectedItems == 0 && _isValidateSubmitted;
      textColor = Theme.of(context).textTheme.subhead.color;
      iconColor = Theme.of(context).primaryColor;
    }else {
      bool isValid = widget.text != null && widget.text.isNotEmpty;
      isRequiredError = widget.isRequired && (widget.text == null || widget.text.isEmpty) && _isValidateSubmitted;
      text = isValid ? widget.text :  widget.placeholder;
      textColor = isValid ? Theme.of(context).primaryColor : Theme.of(context).textTheme.title.color;
      iconColor = isValid ? Theme.of(context).primaryColor : Theme.of(context).unselectedWidgetColor;
    }

    if (isRequiredError) {
      borderColor = Theme.of(context).errorColor;
      helperColor = Theme.of(context).errorColor;
    }

    return new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  border: new Border.all(
                    color: borderColor,
                      width: 1.0
                  )
              ),
              child: new FlatButton(
                padding: const EdgeInsets.all(10.0),
                onPressed: widget.onPressed,
                child: new Row(
                  children: <Widget>[
                    new Center(
                      child: new SizedBox(
                        width: 20.0,
                        height: 30.0,
                        child: Icon(widget.icon,
                          size: 18.0,
                          color: iconColor,
                        ),
                      ),
                    ),
                    new Expanded(child: new Container(
                      padding: new EdgeInsets.only(left: 10.0),
                      child: new Text(text,
                        style: new TextStyle(color: textColor),
                      ),
                    ),),
                    Icon(Icons.arrow_drop_down, size: 18.0, color: Theme.of(context).unselectedWidgetColor,),

                  ],
                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 5.0, left: 10.0),
              child: isRequiredError && widget.helpText != null
                  ? new Text(widget.helpText, style: TextStyle(color: helperColor, fontSize: 12.0),)
                  : null
            )

          ],
        )
    );
  }
}
