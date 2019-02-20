# fab_navigation_bar

This plugin provides you a simple way to create a beautiful bottom navigation bar,
using the power of a FAB button inside it.

## Usage

To use it, you must put the `FabNavigationBar` widget inside a `MaterialApp` widget property `home`. The only required properties for the widget are `itens List<FabNavigationBarIcon>` (which are the itens which will appear in the `FabNavigationBar`) and `fabCallback (VoidCallback)` which is the function executed after we click the Fab button.

Every other property which can be passed to the `FabNavigationBar` is listed below.

An example of usage can be found in the `/examples` folder

![Example gif](/assets/example.gif)

## API

### FabNavigationBar

* `@required List<FabNavigationBarIcon> itens`: Itens which will be added to the `FabNavigationBar`, **NOT** included the FAB itself. *NOTE: As of version 0.1.0, it is recommended to pass an even number of `FabNavigationBarIcon` as the code doesn't handle the spacing with an odd number (it will be weird-looking)*;

* `@required VoidCallback fabCallback`: Function which will be executed when we the FAB button is clicked

* `IconData fabIcon`: Icon which will be shown in the FAB button;

* `PreferredSizeWidget appBar`: Generic AppBar which will be used in the `Scaffold` of the app;
* `Widget body`: Generic body which will be used in the `Scaffold` of the app;
* `Duration fabAnimationDuration`: Duration for the animations on the `fabNavigationBar`;
* `Color fabIconColor`: Color of the icon on the FAB;
* `double fabIconSize`: Size of the icon on the FAB;
* `Color fabBackgroundColor`: Color of the icon background on the FAB;
* `Gradient fabBackgroundGradient`: Gradient color of the icon background on the FAB. If this property is specified, the `fabBackgroundColor` color is not used;
* `BorderRadiusGeometry fabBackgroundBorderRadius`: FAB's format customization;
* `List<BoxShadow> fabBoxShadow`: FAB's BoxShadow property customization;
* `TextStyle navigationBarTextStyle`: TextStyle for the text displayed under the icons on the `FabNavigationBar`;
* `Color selectedNavigationBarItemColor`: Color for the `FabNavigationBarItem` when **selected**;
* `Color notSelectedNavigationBarItemColor`: Color for the `FabNavigationBarItem` when **NOT selected**;

### FabNavigationBarItem

* `@required String name`: Name of the item, which will be displayed under the icon;

* `@required IconData icon`: Icon which will be displayed on the `FabNavigationBar`;

* `@required VoidCallback callback`: Function which will be executed when the `FabNavigationBarItem` is clicked;

## Contributing
Feel free to open an issue if you find any bug, or make a PR!

## Todo List

- [ ] Handle an odd number of `FabNavigationBarItem`'s
- [ ] Give access to more customization of the items
- [ ] Better documentation

## License

MIT License. Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so. The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

## Author
* [Rafael Baldasso Audibert](https://github.com/rafaeelaudibert), CS Bsc. @ UFRGS - [Webpage](https://www.inf.ufrgs.br/~rbaudibert/)