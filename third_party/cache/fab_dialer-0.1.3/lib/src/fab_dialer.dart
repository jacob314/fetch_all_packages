part of fab_dialer;

class FabDialer extends StatefulWidget {
  const FabDialer(this._fabMiniMenuItemList, this._fabColor, this._fabIcon,
    [this._closeFabIcon, this._animationDuration, this.closeOnTap]);

  final List<FabMiniMenuItem> _fabMiniMenuItemList;
  final Color _fabColor;
  final Icon _fabIcon;
  final Icon _closeFabIcon;
  final int _animationDuration;
  final bool closeOnTap;


  @override
  FabDialerState createState() =>
    FabDialerState(
      _fabMiniMenuItemList, _fabColor, _fabIcon, _closeFabIcon,
      _animationDuration, closeOnTap);
}

class FabDialerState extends State<FabDialer> with TickerProviderStateMixin {
  FabDialerState(this._fabMiniMenuItemList, this._fabColor, this._fabIcon,
    this._closeFabIcon, this._animationDuration, this.closeOnTap);

  bool _isRotated = false;
  final List<FabMiniMenuItem> _fabMiniMenuItemList;
  final Color _fabColor;
  final Icon _fabIcon;
  final Icon _closeFabIcon;
  final int _animationDuration;
  final bool closeOnTap;
  List<FabMenuMiniItemWidget> _fabMenuItems;

  AnimationController _controller;

  @override
  void initState() {
    final int animationDuration = _animationDuration == null
      ? 180
      : _animationDuration;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: animationDuration),
    );

    _controller.reverse();

    setFabMenu(this._fabMiniMenuItemList);
    super.initState();
  }

  void setFabMenu(List<FabMiniMenuItem> fabMenuList) {
    List<FabMenuMiniItemWidget> fabMenuItems = List();
    for (int i = 0; i < _fabMiniMenuItemList.length; i++) {
      fabMenuItems.add(FabMenuMiniItemWidget(
        tooltip: _fabMiniMenuItemList[i].tooltip,
        text: _fabMiniMenuItemList[i].text,
        elevation: _fabMiniMenuItemList[i].elevation,
        icon: _fabMiniMenuItemList[i].icon,
        index: i,
        onPressed: _fabMiniMenuItemList[i].onPressed,
        textColor: _fabMiniMenuItemList[i].textColor,
        fabColor: _fabMiniMenuItemList[i].fabColor,
        chipColor: _fabMiniMenuItemList[i].chipColor,
        controller: _controller,
        closeOnPress: closeOnTap,
				close: _rotate
      ));
    }

    this._fabMenuItems = fabMenuItems;
  }

  void _rotate() {
    if (_isRotated) {
      _isRotated = false;
      _controller.reverse();
    } else {
      _isRotated = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Icon closeIcon = _closeFabIcon == null
      ? Icon(Icons.close)
      : _closeFabIcon;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _fabMenuItems,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext _, Widget child) {
                  return FloatingActionButton(
                    child: Transform(
                      transform: Matrix4.rotationZ(
                        (2 * Math.pi) * _controller.value),
                      alignment: Alignment.center,
                      child: _controller.value >= 0.5
                        ? closeIcon
                        : _fabIcon,
                    ),
                    backgroundColor: _fabColor,
                    onPressed: _rotate);
                },
              )
            ],
          ),
        ],
      ));
  }
}
