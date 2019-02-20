library tb_package_print;

/*
* 可根据当前模式判断是否打印log。
* log打印一共分为6个级别，release下只能打印Error级别错误.
* log打印函数可传入临时级别，该级别优先级高于全局级别.
* 如果设置log级别为off，则不会打印任何log.
* */

enum TBPrintLevel{
  Off, //关闭日志打印功能
  Verbose,//详细，显示所有日志消息（最低优先级）
  Debug,//调试，显示仅在开发期间有用的调试日志消息
  Info, //信息，显示常规使用的预计日志消息
  Warning,//警告，显示尚不是错误的潜在问题
  Error, //错误，显示已经引发错误的问题
}

TBPrintLevel globalLevel = TBPrintLevel.Verbose;//默认打印所有的日志

setTBPrintLogLevel(TBPrintLevel level) {
  globalLevel = level;
}

turnOffLogPrint() {
  setTBPrintLogLevel(TBPrintLevel.Off);
}

tbPrint(Object object,{TBPrintLevel level}) {
  if (globalLevel == TBPrintLevel.Off) {
    return;
  }

  // Flutter的四种运行模式：Debug、Release、Profile和test
  //当App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false。
  const bool inProduction = const bool.fromEnvironment("dart.vm.product");
  if (level == null) {
    level = globalLevel;
  }
  if (level == TBPrintLevel.Off) { //关闭状态下不打印任何logo
    return;
  }
  if (inProduction == true ) {
    if (level == TBPrintLevel.Error) { //release模式下，只打印erro级别的Logo
      print('TBLogo:[Error] ' + object);
    }
  } else { //Debug和Profile 模式
    if (level.index >= globalLevel.index) { //release模式下，只打印erro级别的Logo
      print('TBLogo:[$level] ' + object);
    }
  }
}

tbPrintVerbose (object) {
  tbPrint(object, level:TBPrintLevel.Verbose);
}

tbPrintDebug (object) {
  tbPrint(object, level:TBPrintLevel.Debug);
}

tbPrintInfo (object) {
  tbPrint(object, level:TBPrintLevel.Info);
}

tbPrintWarning (object) {
  tbPrint(object, level:TBPrintLevel.Warning);
}

tbPrintError (object) {
  tbPrint(object, level:TBPrintLevel.Error);
}

