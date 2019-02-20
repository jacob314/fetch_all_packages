part of fab_dialer;

typedef void OnFabMiniMenuItemPressed();

class FabMiniMenuItem {
  double elevation;
  String text;
  Icon icon;
  Color fabColor;
  Color chipColor;
  String tooltip;
  Color textColor;
  OnFabMiniMenuItemPressed onPressed;

  FabMiniMenuItem.withText(this.icon,
    this.fabColor,
    this.elevation,
    this.tooltip,
    this.onPressed,
    this.text,
    this.chipColor,
    this.textColor);

  FabMiniMenuItem.noText(this.icon, this.fabColor, this.elevation,
    this.tooltip, this.onPressed){
    this.text = null;
    this.chipColor = null;
    this.textColor = null;
  }
}

class FabMenuMiniItemWidget extends StatelessWidget {
  const FabMenuMiniItemWidget({Key key,
    this.elevation,
    this.text,
    this.icon,
    this.fabColor,
    this.chipColor,
    this.textColor,
    this.tooltip,
    this.index,
    this.controller,
    this.onPressed,
	  this.closeOnPress,
	  this.close})
    : super(key: key);
  final double elevation;
  final String text;
  final Icon icon;
  final Color fabColor;
  final Color chipColor;
  final String tooltip;
  final Color textColor;
  final int index;
  final OnFabMiniMenuItemPressed onPressed;
  final AnimationController controller;
  final bool closeOnPress;
  final Function close;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: controller,
                curve: Interval(((index + 1) / 10), 1.0,
                  curve: Curves.linear),
              ),
              child: chipColor != null
                ? Chip(
                label: Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold),
                ),
                backgroundColor: chipColor,
              ) : null)),
          ScaleTransition(
            scale: CurvedAnimation(
              parent: controller,
              curve:
              Interval(
                ((index + 1) / 10), 1.0, curve: Curves.linear),
            ),
            child: FloatingActionButton(
              elevation: elevation,
              mini: true,
              backgroundColor: fabColor,
              tooltip: tooltip,
              child: icon,
              heroTag: "$index",
              onPressed: () {
								onPressed();
								if (closeOnPress) {
									close();
								}
							}),
          )
        ],
      ));
  }
}
