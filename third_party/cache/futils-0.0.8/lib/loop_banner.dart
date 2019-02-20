import 'dart:async';
import 'package:flutter/material.dart';

typedef LoopBannerItemBuilder = Widget Function(BuildContext context, int position);

class LoopBanner extends StatefulWidget {
  LoopBanner({
    Key key,
    this.aspectRatio = 16 / 9,
    this.itemCount = 0,
    this.initIndex = 0,
    @required this.itemBuilder,
    this.duration = const Duration(seconds: 5),
  }) : assert(itemBuilder != null),
        super(key: key);

  final double aspectRatio;
  final int itemCount;
  final int initIndex;
  final LoopBannerItemBuilder itemBuilder;
  final Duration duration;

  @override
  _LoopBannerState createState() => _LoopBannerState();
}

class _LoopBannerState extends State<LoopBanner> {
  static int _pageCount = 3;
  final int _initialPage = (_pageCount / 2).floor();
  PageController _pageController;
  bool _manualScroll = false; // avoid loop
  int _savedPosition = 0;
  int _itemLeftPosition = 0;
  int _itemCenterPosition = 0;
  int _itemRightPosition = 0;
  Timer _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _renewPageController();
    _setItemPositions(widget.initIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initial auto scroll timer
    _initAutoScrollTimer();
  }

  @override
  void didUpdateWidget(LoopBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    // renew page controller
    _renewPageController();
  }

  @override
  Widget build(BuildContext context) {
    return widget.itemCount <= 0 ?
    _createEmptyItemContainerWidget() :
    widget.itemCount == 1 ?
    _createOneItemContainerWidget() :
    _createFullItemContainerWidget();
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (_autoScrollTimer != null) _autoScrollTimer.cancel();
    super.dispose();
  }

  // renew page controller
  void _renewPageController() {
    if (_pageController != null) {
      _pageController.dispose();
      _pageController = null;
    }
    _pageController = PageController(
      initialPage: _initialPage,
    );
  }

  // set item positions
  void _setItemPositions(int centerPosition) {
    _itemCenterPosition = centerPosition;
    // update left/right item position
    _updateLeftRightItemPosition();
  }

  // left set item positions: ⇇
  void _leftItemPositions() {
    _itemCenterPosition++;
    if (_itemCenterPosition >= widget.itemCount) {
      _itemCenterPosition = 0;
    }
    // update left/right item position
    _updateLeftRightItemPosition();
  }

  // right set item positions: ⇉
  void _rightItemPositions() {
    _itemCenterPosition--;
    if (_itemCenterPosition < 0) {
      _itemCenterPosition = widget.itemCount - 1;
    }
    // update left/right item position
    _updateLeftRightItemPosition();
  }

  // update left/right item position
  void _updateLeftRightItemPosition() {
    _itemLeftPosition = _itemCenterPosition - 1;
    if (_itemLeftPosition < 0) {
      _itemLeftPosition = widget.itemCount - 1;
    }
    _itemRightPosition = _itemCenterPosition + 1;
    if (_itemRightPosition >= widget.itemCount) {
      _itemRightPosition = 0;
    }
  }

  // create empty item container widget
  Widget _createEmptyItemContainerWidget() {
    return Container(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(),
      ),
    );
  }

  // create one item container widget
  Widget _createOneItemContainerWidget() {
    final pos = 0;
    final Widget _itemWidget = widget.itemBuilder(context, pos);
    Widget _child;
    if (_itemWidget == null) {
      _child = _createDefaultItemWidget(context, pos);
    } else {
      _child = _itemWidget;
    }
    return Container(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: _child,
      ),
    );
  }

  // create full item container widget
  Widget _createFullItemContainerWidget() {
    return Container(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: NotificationListener(
          onNotification: _onPageNotification,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pageCount,
            itemBuilder: _createItemWidget,
          ),
        ),
      ),
    );
  }

  // create item widget
  Widget _createItemWidget(BuildContext context, int index) {
    final int pos = index == 0 ? _itemLeftPosition :
    index == 1 ? _itemCenterPosition :
    _itemRightPosition;
    final Widget _itemWidget = widget.itemBuilder(context, pos);
    if (_itemWidget == null) {
      return _createDefaultItemWidget(context, pos);
    } else {
      return _itemWidget;
    }
  }

  // create item default widget
  Widget _createDefaultItemWidget(BuildContext context, int position) {
    return Card(
      color: Color(0xff33b5e5),
      child: Center(
        child: Text('${position + 1}',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // on page notification
  bool _onPageNotification(Notification notification) {
    // update timer use to auto scroll page
    _updateAutoScrollTimer(notification);
    // update saved item position
    _updateSavedItemPosition(notification);
    // flag manual scroll
    _flagManualScroll(notification);
    // check scroll end
    if (_checkPageScrollEnd(notification)) {
      _onPageScrollEndAt(
        _getPageCurrentIndex(notification),
      );
    }
    return false;
  }

  // init auto scroll timer
  void _initAutoScrollTimer() {
    if (_autoScrollTimer != null) _autoScrollTimer.cancel();
    // check duration
    if (widget.duration > Duration(seconds: 1)) {
      _autoScrollTimer = Timer.periodic(
        widget.duration,
        _autoScrollTimerCallback,
      );
    }
  }

  // update timer use to auto scroll page
  void _updateAutoScrollTimer(ScrollNotification notification) {
    // start auto scroll timer
    if (notification is ScrollEndNotification) {
      _initAutoScrollTimer();
    }
    // end auto scroll timer
    else if (notification is ScrollStartNotification) {
      if (_autoScrollTimer != null) _autoScrollTimer.cancel();
      _autoScrollTimer = null;
    }
  }

  // auto scroll timer callback
  void _autoScrollTimerCallback(Timer timer) {
    // reset _manualScroll avoid loop
    _manualScroll = false;
    // animation to page
    _pageController.animateToPage(_pageController.initialPage + 1,
      duration: Duration(milliseconds: 900,),
      curve: Curves.ease,
    ).whenComplete((){
      // change item position
      _changeItemPosition(AxisDirection.left);
    });
  }

  // update saved item position with ScrollStartNotification
  void _updateSavedItemPosition(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _savedPosition = _getPageCurrentIndex(notification);
    }
  }

  // check page scroll end
  bool _checkPageScrollEnd(ScrollNotification notification) {
    return notification is ScrollEndNotification;
  }

  // // get scroll direction from notification
  // AxisDirection _getPageScrollDirection(ScrollNotification notification) {
  //   final PageMetrics metrics = notification.metrics;
  //   final AxisDirection dir = metrics.axisDirection;
  //   return dir;
  // }

  // get current index from notification
  int _getPageCurrentIndex(ScrollNotification notification) {
    final PageMetrics metrics = notification.metrics;
    final int currentPage = metrics.page.round();
    return currentPage;
  }

  // get scroll direction with current index
  AxisDirection _getScrollDirectionWithCurrentIndex(int index) {
    final AxisDirection dir = index > _savedPosition ? AxisDirection.left :
    index < _savedPosition ? AxisDirection.right : null;
    return dir;
  }

  // flag manual scroll
  void _flagManualScroll(ScrollNotification notification) {
    // avoid loop
    _manualScroll = _manualScroll || notification is UserScrollNotification;
  }

  // on page scroll end
  void _onPageScrollEndAt(int index) {
    // only manual
    if (_manualScroll) { // avoid loop
      // check scroll direction
      final AxisDirection dir = _getScrollDirectionWithCurrentIndex(index);
      // change item position
      _changeItemPosition(dir);
    }
  }

  // change item position when page scroll end
  void _changeItemPosition(AxisDirection dir) {
    // reset manual flag
    _manualScroll = false;  // avoid loop
    // is valid direction
    if (dir != null &&
        (dir == AxisDirection.left || dir == AxisDirection.right)) {
      // change item position
      if (dir == AxisDirection.left) { // ⇇
        _leftItemPositions();
      } else if (dir == AxisDirection.right) { // ⇉
        _rightItemPositions();
      }
      // changed item position jump to center page
      _pageController.jumpToPage(_pageController.initialPage);
      // update widgets
      setState((){});
    }
  }
}
