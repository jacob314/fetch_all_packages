import 'package:flutter_test/flutter_test.dart';

import 'package:tb_package_print/tb_package_print.dart';

void main() {
  test('adds one to input values', () {
    //tbPrint('number.value=${number.value}');//默认为Verbose
    setTBPrintLogLevel(TBPrintLevel.Warning);//设置log级别
    //turnOffLogPrint();
    tbPrintVerbose('Verbose');
    tbPrintWarning('Warning');
    tbPrintDebug('Debug');
    tbPrintInfo('Info');
    tbPrintError('Error');
  });
}
