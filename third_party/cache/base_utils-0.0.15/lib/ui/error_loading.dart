import 'package:base_utils/ui/res/colors.dart';
import 'package:base_utils/ui/res/images.dart';
import 'package:base_utils/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorLoadingPage extends StatelessWidget {
  Function onRetry;
  Color backgroundColor;
  double height;
  String message;

  ErrorLoadingPage(
      {@required this.onRetry,
      this.backgroundColor,
      this.height,
      this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10.0),
                width: 109.0,
                height: 94.0,
                child:
                    SvgPicture.asset(AssetsImage.error, package: "base_utils"),
              ),
              Container(
                  margin: EdgeInsets.only(top: 21.0, bottom: 32.0),
                  child: Text(
                    isNotEmpty(message)
                        ? message
                        : "Không tải được dữ liệu.\nXin vui lòng thử lại",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: AssetsColor.greyError),
                    textAlign: TextAlign.center,
                  )),
              RaisedButton(
                child: Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
                onPressed: onRetry,
                color: AssetsColor.retryButtonColor,
              )
            ],
          ),
        ));
  }
}
