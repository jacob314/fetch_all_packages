import 'package:test/test.dart';
import 'package:awareframework_significantmotion/awareframework_significantmotion.dart';

void main(){
  test("test sensor config", (){
    var config = SignificantMotionSensorConfig();
    expect(config.debug, false);
  });
}