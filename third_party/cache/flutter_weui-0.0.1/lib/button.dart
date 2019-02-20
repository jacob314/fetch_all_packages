import 'package:flutter/material.dart';
import 'package:smart_color/smart_color.dart';
import 'package:flutter/services.dart';

///按钮的三种类型
enum ButtonType {
  btnPrimary,
  btnWarn,
  btnDefault,
}

class Button extends StatefulWidget {
  Button({Key key, this.type = ButtonType.btnDefault}) : super(key: key);

  /// 按钮类型
  final ButtonType type;
  @override
  State<StatefulWidget> createState() => _Button();
}

class _ButtonColor {
  Color fontColor ;
  Color activeFontColor ;
  Color disabledFontColor ;

  Color bg ;
  Color activeBg ;
  Color disabledBg;
}

class _ButtonDefault extends _ButtonColor {
   Color fontColor = Color(0xFF000000);
   Color activeFontColor = Color.fromARGB((0.6 * 255).toInt(), 0, 0, 0);
   Color disabledFontColor = Color.fromARGB((0.3 * 255).toInt(), 0, 0, 0);

   Color bg = Color(0xFFF8F8F8);
   Color activeBg = Color(0xFFDEDEDE);
   Color disabledBg = Color(0xFFF7F7F7);
}

class _ButtonWarn extends _ButtonColor{
   Color fontColor = Color(0xFFFFFFFF); //按钮文本颜色
   Color activeFontColor = Color.fromARGB((0.6 * 255).toInt(), 255, 255, 255); //按下时文本颜色
   Color disabledFontColor = Color.fromARGB((0.6 * 255).toInt(), 255, 255, 255); //不可用时文本颜色

   Color bg = Color(0xFFE64340);
   Color activeBg = Color(0xFFCE3C39);
   Color disabledBg = Color(0xFFEC8B89);
}

class _ButtonPrimary extends _ButtonColor{
   Color fontColor = Color(0xFFFFFFFF); //按钮文本颜色
   Color activeFontColor = Color.fromARGB((0.6 * 255).toInt(), 255, 255, 255); //按下时文本颜色
   Color disabledFontColor = Color.fromARGB((0.6 * 255).toInt(), 255, 255, 255); //不可用时文本颜色

   Color bg = Color(0xFF1AAD19);
   Color activeBg = Color(0xFF179B16);
   Color disabledBg = SmartColor.parse("#9ED99D");
}

class _Button extends State<Button> {
  double wuiBtnHeight = 46; //按钮高度
  double wuiBtnFontSize = 18; //按钮文本尺寸
  Color wuiBtnFontColor = Color(0xFFFFFFFF); //按钮文本颜色
  Color wuiBtnActiveFontColor = Color.fromARGB((0.6 * 255).toInt(), 255, 255, 255); //按下时文本颜色
  Color wuiBtnDisabledFontColor = Color.fromARGB((0.6 * 255).toInt(), 255, 255, 255); //不可用时文本颜色
  double wuiBtnBorderRadius = 5; //按钮borderRadius
  Color wuiBtnBorderColor = SmartColor.parse("rgba(0,0,0,.2)"); //按钮border颜色
  double wuiBtnDefaultGap = 15;

  double wuiBtnMiniFontSize = 13;
  double wuiBtnMiniHeight = 2.3;

  Color wuiBtnDefaultFontColor = Color(0xFF000000);
  Color wuiBtnDefaultActiveFontColor = Color.fromARGB((0.6 * 255).toInt(), 0, 0, 0);
  Color wuiBtnDefaultDisabledFontColor = Color.fromARGB((0.3 * 255).toInt(), 0, 0, 0);

  Color wuiBtnDefaultBg = Color(0xFFF8F8F8);
  Color wuiBtnDefaultActiveBg = Color(0xFFDEDEDE);
  Color wuiBtnDefaultDisabledBg = Color(0xFFF7F7F7);

  Color wuiBtnPrimaryBg = Color(0xFF1AAD19);
  Color wuiBtnPrimaryActiveBg = Color(0xFF179B16);
  Color wuiBtnPrimaryDisabledBg = SmartColor.parse("#9ED99D");

  Color wuiBtnWarnBg = Color(0xFFE64340);
  Color wuiBtnWarnActiveBg = Color(0xFFCE3C39);
  Color wuiBtnWarnDisabledBg = Color(0xFFEC8B89);

  Color wuiBtnPlainPrimaryColor = SmartColor.parse("rgba(26,173,25,1)");
  Color wuiBtnPlainPrimaryBorderColor = SmartColor.parse("rgba(26,173,25,1)");
  Color wuiBtnPlainPrimaryActiveColor = SmartColor.parse("rgba(26,173,25,.6)");
  Color wuiBtnPlainPrimaryActiveBorderColor = SmartColor.parse("rgba(26,173,25,.6)");

  Color wuiBtnPlainDefaultColor = SmartColor.parse("rgba(53,53,53,1)");
  Color wuiBtnPlainDefaultBorderColor = SmartColor.parse("rgba(53,53,53,1)");
  Color wuiBtnPlainDefaultActiveColor = SmartColor.parse("rgba(53,53,53,.6)");
  Color wuiBtnPlainDefaultActiveBorderColor = SmartColor.parse("rgba(53,53,53,.6)");

  Color fontColor;
  Color btnColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fontColor = wuiBtnDefaultFontColor;
    btnColor = wuiBtnDefaultBg;
  }

  _ButtonColor _getButtonColor(ButtonType type){
    if(type == ButtonType.btnPrimary)return _ButtonPrimary();
    if(type == ButtonType.btnWarn)return _ButtonWarn();
    return _ButtonDefault();
  }

  _onTapDown(e) {
    setState(() {
      fontColor = wuiBtnDefaultActiveFontColor;
      btnColor = wuiBtnDefaultActiveBg;
    });
  }

  _onTapUp(e) {
    setState(() {
      fontColor = wuiBtnDefaultFontColor;
      btnColor = wuiBtnDefaultBg;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Container(
        height: wuiBtnHeight,
        child: Center(
            child: Text(
          "button",
          style: TextStyle(
            color: fontColor,
            fontSize: wuiBtnFontSize,
          ),
        )),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(
            wuiBtnBorderRadius,
          )),
          border: Border.all(color: wuiBtnBorderColor, width: 1 / MediaQuery.of(context).devicePixelRatio),
          color: btnColor,
        ),
      ),
    );
  }
}
