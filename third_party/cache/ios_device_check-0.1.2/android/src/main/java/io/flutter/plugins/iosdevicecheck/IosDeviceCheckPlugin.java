package io.flutter.plugins.iosdevicecheck;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class IosDeviceCheckPlugin implements MethodCallHandler {
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/ios_device_check");
    channel.setMethodCallHandler(new IosDeviceCheckPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    result.notImplemented();
  }
}
