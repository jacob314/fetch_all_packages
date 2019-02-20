import 'package:flutter/material.dart';
import 'package:shimcharts/beans/option_bean.dart';
import 'package:shimcharts/beans/calculate_opt.dart';


class CYAxis {
  BYAxis yAxis;
  CalculateOpt cOpt;
  

  CYAxis.initByMap(Map map, this.cOpt) {
    yAxis = new BYAxis.fromJson(map);
  }

  CYAxis.initByBean(BYAxis bean, this.cOpt) {
    yAxis = bean;
  }

  void paint(Canvas canvas, Size size) {
    Paint lineP = new Paint();
    lineP.color = Colors.black;
    lineP.strokeWidth = 1.0;    

    Paint subLineP = new Paint();
    subLineP.strokeWidth = 1.0;
    subLineP.color = Colors.black12;

    canvas.drawLine(new Offset(cOpt.startX, cOpt.startY), new Offset(cOpt.startX, cOpt.endY), lineP);

    for (int i = cOpt.splitY; i >= 0 ; i--) {
      canvas.drawLine(new Offset(cOpt.startX - 4, cOpt.startY + i * cOpt.realHeight / cOpt.splitY), new Offset(cOpt.startX, cOpt.startY + i * cOpt.realHeight / cOpt.splitY), lineP);
      canvas.drawLine(new Offset(cOpt.startX, cOpt.startY + i * cOpt.realHeight / cOpt.splitY), new Offset(cOpt.endX, cOpt.startY + i * cOpt.realHeight / cOpt.splitY), subLineP);

      TextSpan span = new TextSpan(
        text: (cOpt.startYNum + cOpt.yStep * (cOpt.splitY - i)).toString(),
        style: new TextStyle(
          // height: 30.0
          fontSize: 16.0,
          color: Colors.black
        )
      );
      TextPainter tp = new TextPainter(
        text: span, 
        textAlign: TextAlign.right, 
        textDirection: TextDirection.ltr
      );
      tp.layout(minWidth: cOpt.paddingX - cOpt.disText);
      tp.paint(canvas, new Offset(0.0, cOpt.startY + i * cOpt.realHeight / cOpt.splitY - 9));
    }
  }

}