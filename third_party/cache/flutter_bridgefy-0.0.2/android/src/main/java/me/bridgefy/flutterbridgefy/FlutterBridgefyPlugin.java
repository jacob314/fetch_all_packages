package me.bridgefy.flutterbridgefy;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterBridgefyPlugin */
public class FlutterBridgefyPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_bridgefy");
    channel.setMethodCallHandler(new FlutterBridgefyPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    
    if (call.method.equals("init")) {
      result.success();
    } else {
      result.notImplemented();
    }
    
  }
}
