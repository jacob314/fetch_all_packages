import 'package:flutter/material.dart';

typedef SearchCallback<T> = Future<List<T>> Function(String text);

Future<T> showGenericDialog<T>(
    {@required BuildContext context,
    @required String title,
    int minimumLenghtRequired,
    SearchCallback<T> searchCallback}) async {
  assert(context != null);
  assert(title != null);
  return await showDialog<T>(
      context: context,
      builder: (context) => GenericDialog(
            title: title,
            minimumLenghtRequired: minimumLenghtRequired,
            searchCallback: searchCallback,
          ));
}

class GenericDialog<T> extends StatefulWidget {
  GenericDialog(
      {Key key, this.title, this.minimumLenghtRequired: 3, this.searchCallback})
      : assert(title != null),
        super(key: key);

  final String title;
  final int minimumLenghtRequired;
  final SearchCallback<T> searchCallback;

  @override
  _GenericDialogState createState() => _GenericDialogState();
}

class _GenericDialogState<T> extends State<GenericDialog> {
  // @override
  // void initState() {
  //   super.initState();
  //   _selected = widget.initialValue;
  // }

  // T get selectedCategory => _selected;
  // T _selected;
  List<T> _list;
  String _text;
  var _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData media = MediaQuery.of(context);
    final Container header = Container(
      color: theme.primaryColor,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.title,
                  style: theme.primaryTextTheme.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.cancel,
                  color: theme.primaryTextTheme.display1.color,
                ),
                onTap: () => Navigator.pop(context),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _key,
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Ingrese texto a buscar...'),
                    validator: (s) {
                      return (s.length < widget.minimumLenghtRequired)
                          ? 'Debe ingresar al menos ${widget.minimumLenghtRequired} caracteres'
                          : null;
                    },
                    onSaved: (s) => _text = s,
                  ),
                ),
              ),
              InkWell(
                child: Icon(
                  Icons.search,
                  color: theme.primaryTextTheme.display1.color,
                ),
                onTap: () {
                  if (_key.currentState.validate()) {
                    _key.currentState.save();
                    if (widget.searchCallback != null)
                      widget.searchCallback(_text).then(
                          (l) => setState(() => setState(() => _list = l)));
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
    final Widget list = _list == null
        ? Center(
            child: Text('No se encuentran resultados en su búsqueda'),
          )
        : ListView(
            children: _list
                .map((f) => Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                      child: InkWell(
                        child: Text('$f'),
                        onTap: () => Navigator.pop(context, f),
                      ),
                    ))
                .toList(),
          );
    final Widget body = Column(
      children: <Widget>[
        header,
        Expanded(
          child: Container(
            color: theme.dialogBackgroundColor,
            child: list,
          ),
        )
      ],
    );
    final Dialog dialog = Dialog(
      child: SizedBox(
        width: media.size.width * 0.9,
        height: media.size.height * 0.75,
        child: body,
      ),
    );
    return Theme(
      data: theme.copyWith(dialogBackgroundColor: Colors.transparent),
      child: dialog,
    );
  }
}
