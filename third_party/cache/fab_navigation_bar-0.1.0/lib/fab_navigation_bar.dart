/// Flutter plugin which implements a beautiful navigation bar using the FAB button
///
/// This plugin provides you a simple way to create a beautiful bottom navigation bar,
/// using the power of a FAB button inside it.
library fab_navigation_bar;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Class which is used on the main class [FabNavigationBar] to represent
/// the icons which will be displayed on it.
///
/// All the parameters are required
class FabNavigationBarIcon {
  final String name;
  final IconData icon;
  final VoidCallback callback;

  FabNavigationBarIcon(
      {@required this.name, @required this.icon, @required this.callback});
}

/// Main application class.
/// It should be used inside of a [MaterialApp] widget, as it uses [MediaQuery]
/// to calculate the height of the [Scaffold.bottomNavigationBar]
class FabNavigationBar extends StatefulWidget {
  final List<FabNavigationBarIcon> itens;
  final VoidCallback fabCallback;
  final IconData fabIcon;
  final PreferredSizeWidget appBar;
  final Widget body;
  final Duration fabAnimationDuration;
  final Color fabIconColor;
  final double fabIconSize;
  final Color fabBackgroundColor;
  final Gradient fabBackgroundGradient;
  final BorderRadiusGeometry fabBackgroundBorderRadius;
  final List<BoxShadow> fabBoxShadow;
  final TextStyle navigationBarTextStyle;
  final Color selectedNavigationBarItemColor;
  final Color notSelectedNavigationBarItemColor;

  FabNavigationBar(
      {@required this.itens,
      @required this.fabCallback,
      this.fabIcon,
      this.appBar,
      this.body,
      this.fabAnimationDuration = const Duration(milliseconds: 250),
      this.fabIconColor,
      this.fabIconSize,
      this.fabBackgroundColor,
      this.fabBackgroundGradient,
      this.fabBackgroundBorderRadius,
      this.fabBoxShadow,
      this.selectedNavigationBarItemColor,
      this.notSelectedNavigationBarItemColor,
      this.navigationBarTextStyle = const TextStyle()});

  @override
  _FabNavigationBarState createState() => _FabNavigationBarState();
}

/// State for the [FabNavigationBar] class
class _FabNavigationBarState extends State<FabNavigationBar> {
  /// Default selected page is the first one
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: widget.appBar,
        body: widget.body,
        bottomNavigationBar: _bottomNavigationBar(),
        floatingActionButton: _fab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );

  /// Helper to calculate a percentage of the current view height
  /// Uses [MediaQuery], this is why we need to have our [FabNavigationBar]
  /// inside of a [MaterialApp] widget
  mediaQueryHeightPercentage(double percentage) =>
      (MediaQuery.of(context).size.height / 100) * percentage;

  /// Helper to calculate a percentage of the current view width
  /// Uses [MediaQuery], this is why we need to have our [FabNavigationBar]
  /// inside of a [MaterialApp] widget
  mediaQueryWidthPercentage(double percentage) =>
      (MediaQuery.of(context).size.width / 100) * percentage;

  /// Private method which properly build the [FabNavigationBar]
  _bottomNavigationBar() {
    List<BottomNavigationBarItem> itens = List();

    // We need to use a normal for instead of a list.forEach,
    // because we need the index
    widget.itens.asMap().forEach(
          (index, item) => itens.add(
                BottomNavigationBarItem(
                  icon: Icon(
                    item.icon,
                    color: selectedPage ==
                            (index < widget.itens.length ~/ 2
                                ? index
                                : index + 1)
                        ? widget.selectedNavigationBarItemColor ?? Colors.black
                        : widget.notSelectedNavigationBarItemColor ??
                            Colors.grey[500],
                  ),
                  title: Text(
                    item.name,
                    style: widget.navigationBarTextStyle.apply(
                      color: selectedPage ==
                              (index < widget.itens.length ~/ 2
                                  ? index
                                  : index + 1)
                          ? widget.selectedNavigationBarItemColor ??
                              Colors.black
                          : widget.notSelectedNavigationBarItemColor ??
                              Colors.grey[500],
                    ),
                  ),
                ),
              ),
        );

    itens.insert(
      itens.length ~/ 2,
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.home, color: ColorPalette.backgroundColor),
        title:
            Text('Home', style: TextStyle(color: ColorPalette.backgroundColor)),
      ),
    );

    return BottomNavigationBar(
      currentIndex: selectedPage,
      onTap: (selection) => setState(() {
            // Emit callbacks, handling the fab offset
            if (selection != selectedPage) {
              if (selection != itens.length ~/ 2) {
                widget.itens[selection > itens.length ~/ 2
                        ? selection - 1
                        : selection]
                    .callback();
              } else {
                widget.fabCallback();
              }

              selectedPage = selection;
            }
          }),
      items: itens,
    );
  }

  /// Private method which properly builds the FAB in an [AnimatedContainer]
  _fab() {
    final int fabEntry = widget.itens.length ~/ 2;

    return AnimatedContainer(
      duration: widget.fabAnimationDuration,
      margin: selectedPage == fabEntry
          ? EdgeInsets.only(top: mediaQueryHeightPercentage(3))
          : EdgeInsets.only(
              top: mediaQueryHeightPercentage(5),
              right:
                  selectedPage > fabEntry ? mediaQueryWidthPercentage(8) : 0.0,
              left:
                  selectedPage < fabEntry ? mediaQueryWidthPercentage(8) : 0.0,
            ),
      height: selectedPage == fabEntry
          ? mediaQueryHeightPercentage(8)
          : mediaQueryHeightPercentage(7),
      width: selectedPage == fabEntry
          ? mediaQueryHeightPercentage(8)
          : mediaQueryHeightPercentage(7),
      decoration: BoxDecoration(
        borderRadius: widget.fabBackgroundBorderRadius ??
            BorderRadius.circular(mediaQueryHeightPercentage(2.5)),
        color: widget.fabBackgroundColor ?? Colors.blueAccent,
        gradient: widget.fabBackgroundGradient,
        boxShadow: selectedPage == fabEntry
            ? widget.fabBoxShadow ??
                [
                  BoxShadow(
                    color: ColorPalette.primaryColor.withOpacity(0.6),
                    blurRadius: 25,
                    offset: Offset(0, 10),
                  ),
                ]
            : null,
      ),
      child: InkWell(
        borderRadius: widget.fabBackgroundBorderRadius ??
            BorderRadius.circular(mediaQueryHeightPercentage(2.5)),
        onTap: () {
          setState(() {
            if (selectedPage != fabEntry) {
              widget.fabCallback();
              selectedPage = fabEntry;
            }
          });
        },
        child: Icon(
          widget.fabIcon ?? FontAwesomeIcons.plus,
          size: widget.fabIconSize ?? mediaQueryHeightPercentage(3),
          color: widget.fabIconColor ?? Colors.white,
        ),
      ),
    );
  }
}

/// Generic class which handles some default colors which are used as default
/// by the [FabNavigationBar] and its [FabNavigationBarItem]s
class ColorPalette {
  static Color backgroundColor = Color(0xFFFCFCFC);
  static Color primaryColor = Color(0xFFAD5389);
  static Color gradientSecondaryColor = Color(0xFF3C1053);

  static List<Color> appThemedGradientColors = [
    primaryColor,
    gradientSecondaryColor,
  ];

  static List<Color> appThemedGradientColorsPremium = [
    Color(0xFFFBAB66),
    Color(0xFFF7418C),
  ];
}
