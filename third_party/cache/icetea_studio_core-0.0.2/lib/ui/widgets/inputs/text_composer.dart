import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final String hintText;

  TextComposer({this.onSubmitted, this.hintText = ""})
      : assert(onSubmitted != null);

  @override
  TextComposerState createState() {
    return new TextComposerState();
  }
}

class TextComposerState extends State<TextComposer> {
  final _inputController = new TextEditingController();
  bool _isAllowSubmit = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(left: 40.0, bottom: 10.0),
      decoration: new BoxDecoration(color: Theme.of(context).cardColor),
      child: new Row(
        children: <Widget>[
          new Flexible(
              child: TextField(
                controller: _inputController,
                textInputAction: TextInputAction.send ,
                onSubmitted: (String text) {
                  widget.onSubmitted(_inputController.text);
                  _isAllowSubmit = false;
                  _inputController?.clear();
                  setState(() {

                  });
                },
                onChanged: (String text) {
                  if (text.isNotEmpty && _isAllowSubmit == false) {
                    _isAllowSubmit = true;
                    setState(() {

                    });
                  } else if (text.isEmpty) {
                    _isAllowSubmit = false;
                    setState(() {

                    });
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: widget.hintText,
                ),
              )
          ),
          new Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.send, color: _isAllowSubmit ? Theme
                    .of(context)
                    .iconTheme
                    .color : Theme
                    .of(context)
                    .disabledColor,),
                onPressed: (){
                  if (_isAllowSubmit) {
                    _isAllowSubmit = false;
                    widget.onSubmitted(_inputController.text);
                    _inputController.clear();
                    setState(() {

                    });
                  }
                }
            ),
          )
        ],
      ),
    );
  }
}
