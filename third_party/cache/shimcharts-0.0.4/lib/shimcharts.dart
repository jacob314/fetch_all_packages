library shimcharts;

import 'package:flutter/material.dart';
import 'package:shimcharts/beans/option_bean.dart';
import 'package:shimcharts/beans/calculate_opt.dart';
import 'package:shimcharts/components/cseries_lines.dart';
import 'package:shimcharts/components/cxaxis.dart';
import 'package:shimcharts/components/cyaxis.dart';


class ShimCharts {

  OptionBean option;
  CalculateOpt cOpt;

  ShimCharts.fromJson(Map option) {
    this.option = new OptionBean.fromJson(option);
  }

  ShimCharts(this.option);

  void paint(Canvas canvas, Size size) {
    this.cOpt = new CalculateOpt.initFromBean(this.option, size.height, size.width);
    new CXAxis.initByBean(option.xAxis, this.cOpt).paint(canvas, size);
    new CYAxis.initByBean(option.yAxis, this.cOpt).paint(canvas, size);
    new CSeriesLines.initByBean(option.series, this.cOpt).paint(canvas, size);
    
  }
}
