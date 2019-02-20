
class OptionBean {
  BXAxis xAxis;
  BYAxis yAxis;
  List<BSeriesItem> series;

  OptionBean.fromJson(Map option) {
    this.xAxis = new BXAxis.fromJson(option['xAxis']);
    this.yAxis = new BYAxis.fromJson(option['yAxis']);
    this.series = new List<BSeriesItem>();
    option['series'].forEach((item) {
      this.series.add(new BSeriesItem.fromJson(item));
    });
  }

}

class BXAxis {
  String type;
  List<String> data;

  BXAxis.fromJson(Map xAxis) {
    this.type = xAxis['type'];
    this.data = xAxis['data'];
  }

}

class BYAxis {
  String type;

  BYAxis.fromJson(Map yAxis) {
    this.type = yAxis['type'];
  }

}

class BSeriesItem {
  List<num> data;
  String type;
  bool smooth;

  BSeriesItem.fromJson(Map seriesItem) {
    this.data = seriesItem['data'];
    this.type = seriesItem['type'];
    this.smooth = seriesItem['smooth'];
  }

}