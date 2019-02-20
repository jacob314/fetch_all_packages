package com.ly.fluchar;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlucharPlugin */
public class FlucharPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "fluchar");
    channel.setMethodCallHandler(new FlucharPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("char")) {
      String s = call.argument("str");
      char c = (char) Integer.parseInt(s);
      result.success(String.valueOf(c));
    } else {
      result.notImplemented();
    }
  }
}
