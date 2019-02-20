import 'package:base_utils/ui/res/dimens.dart';
import 'package:base_utils/ui/res/images.dart';
import 'package:flutter/material.dart';

const TO_TOP_BUTTON_VISIBLE_THRESHOLD = 700.0;

const TO_TOP_BUTTON_ANIMATION_THRESHOLD = 1500.0;

class BaseListWidget extends StatefulWidget {
  BaseListWidget(
      {this.child,
      this.onRefresh,
      this.hasToTop = true,
      this.scrollController});

  final Function onRefresh;

  final bool hasToTop;

  final Widget child;

  final ScrollController scrollController;

  @override
  _BaseListWidgetState createState() => _BaseListWidgetState();
}

class _BaseListWidgetState extends State<BaseListWidget>
    with AutomaticKeepAliveClientMixin<BaseListWidget> {
  bool _toTopVisibility = false;

  double currentOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              currentOffset = notification.metrics.pixels;
              if (currentOffset >= TO_TOP_BUTTON_VISIBLE_THRESHOLD) {
                toggleToTop(true);
              } else {
                toggleToTop(false);
              }
            }
          },
          child: Stack(
            children: <Widget>[
              widget.child,
              Positioned(
                right: AssetsDimen.toTopButtonMarginRight,
                bottom: AssetsDimen.toTopButtonMarginBottom,
                child: buildScrollUpButton(),
              )
            ],
          )),
    );
  }

  void toggleToTop(bool visibility) {
    setState(() {
      _toTopVisibility = visibility;
    });
  }

  Widget buildScrollUpButton() {
    return AnimatedOpacity(
        opacity: _toTopVisibility && widget.hasToTop ? 1.0 : 0.0,
        duration: Duration(milliseconds: 200),
        child: Material(
          elevation: 4.0,
          shape: CircleBorder(),
          color: Colors.transparent,
          child: Ink.image(
            image:
                AssetImage(AssetsImage.toTopImageAsset, package: "base_utils"),
            fit: BoxFit.cover,
            width: AssetsDimen.toTopButtonSize,
            height: AssetsDimen.toTopButtonSize,
            child: InkWell(
                onTap: () {
                  if (currentOffset <= TO_TOP_BUTTON_ANIMATION_THRESHOLD) {
                    widget.scrollController.animateTo(0.0,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                  } else {
                    widget.scrollController.jumpTo(0.01);
                  }
                  toggleToTop(false);
                },
                child: null),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
