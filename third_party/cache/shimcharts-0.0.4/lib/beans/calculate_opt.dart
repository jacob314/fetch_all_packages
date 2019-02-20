import 'package:shimcharts/beans/option_bean.dart';

class CalculateOpt {
  OptionBean option;

  num paddingX;
  num paddingY;
  num disText;
  num realHeight;
  num realWidth;
  num startX;
  num endX;
  num startY;
  num endY;
  num viewHeight;
  num viewWidth;
  num splitX;
  num splitY;
  num yStep;
  num startYNum;
  num maxYNum;

  CalculateOpt.initFromMap(Map map, this.viewHeight, this.viewWidth) {
    this.option = new OptionBean.fromJson(map);
    this.init();
  }

  CalculateOpt.initFromBean(this.option, this.viewHeight, this.viewWidth) {
    this.init();
  }

  void init() {
    this.paddingX = 40.0;
    this.paddingY = 40.0;
    this.disText = 6.0;
    this.realHeight = viewHeight - 2 * paddingY;
    this.realWidth = viewWidth - 2 * paddingX;
    this.startX = paddingX;
    this.endX = paddingX + realWidth;
    this.startY = paddingY;
    this.endY = paddingY + realHeight;
    this.splitX = this.option.xAxis.data.length;
    this.splitY = 5;
    this.startYNum = 0;

    this.maxYNum = 0.0;
    this.option.series.forEach((listVal) {
      listVal.data.forEach((val) {
        if (val > maxYNum) {
          maxYNum = val;
        }
      });
    });
    
    this.yStep = maxYNum / splitY;
  }

}