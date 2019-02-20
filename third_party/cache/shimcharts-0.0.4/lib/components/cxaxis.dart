import 'package:flutter/material.dart';
import 'package:shimcharts/beans/option_bean.dart';
import 'package:shimcharts/beans/calculate_opt.dart';


class CXAxis {
  BXAxis xAxis;
  CalculateOpt cOpt;
  

  CXAxis.initByMap(Map map, this.cOpt) {
    xAxis = new BXAxis.fromJson(map);
  }

  CXAxis.initByBean(BXAxis bean, this.cOpt) {
    xAxis = bean;
  }

  void paint(Canvas canvas, Size size) {
    List<String> list = this.xAxis.data;
    Paint lineP = new Paint();
    lineP.color = Colors.black;
    lineP.strokeWidth = 1.0;
    
    canvas.drawLine(new Offset(cOpt.startX, cOpt.endY), new Offset(cOpt.endX, cOpt.endY), lineP);

    for (int i = 1; i <= cOpt.splitX ; i++) {
      canvas.drawLine(new Offset(cOpt.startX + i * cOpt.realWidth / cOpt.splitX, cOpt.endY), new Offset(cOpt.startX + i * cOpt.realWidth / cOpt.splitX, cOpt.endY + 4), lineP);

      TextSpan span = new TextSpan(
        text: (list[i - 1]).toString(),
        style: new TextStyle(
          fontSize: 16.0,
          color: Colors.black
        )
      );
      TextPainter tp = new TextPainter(
        text: span, 
        textAlign: TextAlign.center, 
        textDirection: TextDirection.ltr
      );
      tp.layout(minWidth: cOpt.realWidth / cOpt.splitX);
      tp.paint(canvas, new Offset(cOpt.startX + (i - 1) * cOpt.realWidth / cOpt.splitX, cOpt.endY));
    }
  }

}