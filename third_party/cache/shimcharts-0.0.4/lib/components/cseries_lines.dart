import 'package:flutter/material.dart';
import 'package:shimcharts/beans/option_bean.dart';
import 'package:shimcharts/beans/calculate_opt.dart';

class CSeriesLines {

  List<BSeriesItem> series;
  CalculateOpt cOpt;

  CSeriesLines.initByBean(List<BSeriesItem> bean, this.cOpt) {
    this.series = bean;
  }

  void paint(Canvas canvas, Size size) {
    this.series.forEach((item) {
      Paint pointP = new Paint();
      pointP.color = Colors.black;
      pointP.strokeWidth = 2.0;


      Paint linePaint = new Paint();
      linePaint.color = Colors.orange;
      linePaint.strokeWidth = 2.0;

      List list = item.data;
      for (int i = 0; i < list.length; i++) {
        dynamic x = cOpt.startX + (i + 1/2) * cOpt.realWidth / cOpt.splitX;
        dynamic y = cOpt.paddingY + cOpt.realHeight * (1 - list[i] / (cOpt.maxYNum - 0));

        canvas.drawCircle(new Offset(x, y), 4.0, pointP);

        if (i != 0) {
          dynamic x_1 = cOpt.startX + (i - 1 + 1/2) * cOpt.realWidth / cOpt.splitX;
          dynamic y_1 = cOpt.paddingY + cOpt.realHeight * (1 - list[i - 1] / (cOpt.maxYNum - 0));
          canvas.drawLine(new Offset(x_1, y_1), new Offset(x, y), linePaint);
        }
      }
    });
  }

}