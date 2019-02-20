import 'package:flutter/material.dart';
import 'package:icetea_studio_core/ui/i18n/strings.dart';
import 'package:icetea_studio_core/ui/styles/theme_input_search.dart';
import 'package:icetea_studio_core/ui/styles/theme_primary.dart';

class SearchInputFilter extends StatefulWidget {

  final ValueChanged<String> onChanged;
  final String hintText;

  SearchInputFilter({@required this.onChanged, this.hintText}) : assert(onChanged != null);

  @override
  _SearchInputFilterState createState() => _SearchInputFilterState();
}

class _SearchInputFilterState extends State<SearchInputFilter> {
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: buildSearchInputTheme(context),
        child: new Container(
            decoration: new BoxDecoration(
                color: buildPrimaryTheme(context).backgroundColor,
                border: new Border(bottom: BorderSide(
                    color: Theme
                        .of(context)
                        .dividerColor),
                )
            ),
            padding: new EdgeInsets.all(15.0),
            child: new Container(
              padding: new EdgeInsets.all(10.0),
//              margin: new EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: new BoxDecoration(
                  color: buildSearchInputTheme(context).backgroundColor,
                  borderRadius: new BorderRadius.all(new Radius.circular(50.0))
              ),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(right: 10.0),
                    child: new Icon(Icons.search, size: 20.0,),
                  ),
                  new Expanded(
                    child: new TextField(
                      decoration: new InputDecoration(
                          hintText: widget.hintText != null && widget.hintText
                              .trim()
                              .length != 0 ? widget.hintText : ""
                      ),
                      textInputAction: TextInputAction.search,
                      style: buildSearchInputTheme(context).textTheme.title,
                      onChanged: (String value) {
                        widget.onChanged(value);
                      },
                      controller: inputController,
                    ),
                  ),
                ],
              ),
            )
        ));
  }

}
