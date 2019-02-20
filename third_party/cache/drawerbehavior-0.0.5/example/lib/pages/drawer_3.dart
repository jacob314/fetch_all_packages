import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';

class Drawer3 extends StatefulWidget {
  @override
  _Drawer3State createState() => _Drawer3State();
}

class _Drawer3State extends State<Drawer3> {
  final menu = new Menu(
    items: [
      new MenuItem(
        id: 'restaurant',
        title: 'THE PADDOCK',
      ),
      new MenuItem(
        id: 'other1',
        title: 'THE HERO',
      ),
      new MenuItem(
        id: 'other2',
        title: 'HELP US GROW',
      ),
      new MenuItem(
        id: 'other3',
        title: 'SETTINGS',
      ),
    ],
  );

  var selectedMenuItemId = 'restaurant';
  var _widget = Text("1");

  @override
  Widget build(BuildContext context) {
    return new DrawerScaffold(
        percentage: 1,
        appBar: AppBarProps(
            title: Text("Drawer 3"),
            actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})]),
        menuView: new MenuView(
          textStyle: TextStyle(color: Colors.white, fontSize: 24.0),
          menu: menu,
          animation: false,
          mainAxisAlignment: MainAxisAlignment.start,
          color: Theme.of(context).primaryColor,
          selectedItemId: selectedMenuItemId,
          onMenuItemSelected: (String itemId) {
            selectedMenuItemId = itemId;
            if (itemId == 'restaurant') {
              setState(() => _widget = Text("1"));
            } else {
              setState(() => _widget = Text("default"));
            }
          },
        ),
        contentView: Screen(
          contentBuilder: (context) => Center(child: _widget),
          color: Colors.white,
        ));
  }
}
