import 'package:flutter/material.dart';

abstract class BaseStateView extends StatelessWidget {
  final VoidCallback onItemInteraction;

  const BaseStateView({this.onItemInteraction});

  @override
  Widget build(BuildContext context) {

    var iconSize = MediaQuery.of(context).size.width / 2;

    return new InkWell(
      child: new Center(
        child: new SizedBox(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                width: iconSize,
                height: iconSize,
                child: buildIconView(context),
              ),
              new Padding(padding: EdgeInsets.all(10.0),
                child: new Text(buildMessage(context), style: new TextStyle(color: Theme.of(context).textTheme.subhead.color),
                textAlign: TextAlign.center,
                ),
              ),

            ],
          ),
        ),
      ),
      onTap: onItemInteraction,
    );
  }

  Widget buildIconView(BuildContext context);

  String buildMessage(BuildContext context);
}
