import 'package:flutter/material.dart';

class HeaderSectionTitle extends StatelessWidget {
  final String highlightTitle;
  final String title;
  final IconData icon;

  HeaderSectionTitle({
    Key key,
    this.highlightTitle,
    this.title,
    this.icon
  }):super(key: key);

  Widget _buildWidget(BuildContext context){
    var wrapWidgets = <Widget>[];

    if(this.icon != null){
      wrapWidgets.add(
          Container(
              margin: EdgeInsets.only(right: 5.0),
              child: Icon(
                this.icon,
                color: Theme.of(context).primaryColor,
                size: 18.0,
              )));
    }

    if(this.highlightTitle != null){
      wrapWidgets.add(Text(
        this.highlightTitle,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold
        ),
      ));
    }

    if(this.title != null){
      if(this.highlightTitle != null){
        wrapWidgets.add(Text(' & ', style: TextStyle(
          color: Theme.of(context).textTheme.title.color
        )));
      }

      wrapWidgets.add(
          Text(
            this.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.title.color
            ),
          )
      );
    }

    return  Wrap(
      alignment: WrapAlignment.start,
      children: wrapWidgets
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }
}