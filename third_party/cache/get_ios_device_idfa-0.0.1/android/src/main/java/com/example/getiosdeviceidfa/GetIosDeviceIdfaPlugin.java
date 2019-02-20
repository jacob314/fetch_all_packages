package com.example.getiosdeviceidfa;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** GetIosDeviceIdfaPlugin */
public class GetIosDeviceIdfaPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "get_ios_device_idfa");
    channel.setMethodCallHandler(new GetIosDeviceIdfaPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getIDFA")) {
      result.notImplemented();
    }
  }
}
